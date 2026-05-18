import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { CreateEventDto } from './dto/create-event.dto';

@Injectable()
export class EventsService {
  constructor(
    private prisma: PrismaService,
    private notifications: NotificationsService,
  ) {}

  async create(dto: CreateEventDto) {
    const event = await this.prisma.healthEvent.create({
      data: {
        type: dto.type,
        childName: dto.childName,
        notes: dto.notes,
        payload: dto.payload ?? undefined,
        occurredAt: dto.occurredAt ? new Date(dto.occurredAt) : new Date(),
      },
    });

    const summary = this.buildSummary(dto);
    await this.notifications.broadcastEventNotification({
      type: dto.type,
      childName: dto.childName,
      summary,
    });

    return event;
  }

  async findAll() {
    return this.prisma.healthEvent.findMany({
      orderBy: { occurredAt: 'desc' },
    });
  }

  private buildSummary(dto: CreateEventDto): string {
    switch (dto.type) {
      case 'MEDICINE': {
        const med = dto.payload as any;
        return `Took ${med?.medicineName ?? 'medicine'} — ${med?.doseMg ?? '?'}${med?.unit ?? 'mg'}`;
      }
      case 'TEMPERATURE': {
        const temp = dto.payload as any;
        return `Temperature: ${temp?.valueCelsius ?? '?'}°C (${temp?.method ?? 'measured'})`;
      }
      case 'CUSTOM': {
        const custom = dto.payload as any;
        return custom?.label ?? dto.notes ?? 'Custom event logged';
      }
      default:
        return 'Health event logged';
    }
  }
}
