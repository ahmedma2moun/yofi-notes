import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEventDto } from './dto/create-event.dto';

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
      orderBy: { occurredAt: 'desc' },
    });
  }
}
