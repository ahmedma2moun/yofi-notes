import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEventDto } from './dto/create-event.dto';
import { UpdateEventDto } from './dto/update-event.dto';

@Injectable()
export class EventsService {
  constructor(private prisma: PrismaService) {}

  async create(dto: CreateEventDto) {
    return this.prisma.healthEvent.create({
      data: {
        type: dto.type,
        childName: dto.childName,
        notes: dto.notes,
        payload: dto.payload !== undefined ? (dto.payload as Prisma.InputJsonValue) : undefined,
        occurredAt: dto.occurredAt ? new Date(dto.occurredAt) : new Date(),
      },
    });
  }

  async findAll() {
    return this.prisma.healthEvent.findMany({
      where: { childId: null },
      orderBy: { occurredAt: 'desc' },
    });
  }

  async update(id: string, dto: UpdateEventDto) {
    await this.findOneOrFail(id);
    return this.prisma.healthEvent.update({
      where: { id },
      data: {
        ...(dto.type && { type: dto.type }),
        ...(dto.childName && { childName: dto.childName }),
        ...(dto.notes !== undefined && { notes: dto.notes }),
        ...(dto.payload !== undefined && { payload: dto.payload as Prisma.InputJsonValue }),
        ...(dto.occurredAt && { occurredAt: new Date(dto.occurredAt) }),
      },
    });
  }

  async remove(id: string) {
    await this.findOneOrFail(id);
    await this.prisma.healthEvent.delete({ where: { id } });
  }

  private async findOneOrFail(id: string) {
    const event = await this.prisma.healthEvent.findUnique({ where: { id } });
    if (!event) throw new NotFoundException(`Event ${id} not found`);
    return event;
  }
}
