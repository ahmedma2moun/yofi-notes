import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreateChildDto } from './dto/create-child.dto';
import { UpdateChildDto } from './dto/update-child.dto';
import { CreateChildEventDto } from './dto/create-child-event.dto';

@Injectable()
export class ChildrenService {
  constructor(private prisma: PrismaService) {}

  // ── Children CRUD ──────────────────────────────────────────────────────────

  async findAll(userId: string) {
    const owned = await this.prisma.child.findMany({
      where: { ownerId: userId },
      orderBy: { createdAt: 'asc' },
    });
    const shared = await this.prisma.child.findMany({
      where: { shares: { some: { userId } } },
      orderBy: { createdAt: 'asc' },
    });
    return [...owned, ...shared];
  }

  async create(userId: string, dto: CreateChildDto) {
    return this.prisma.child.create({
      data: {
        name: dto.name,
        birthDate: dto.birthDate ? new Date(dto.birthDate) : undefined,
        ownerId: userId,
      },
    });
  }

  async findOne(userId: string, childId: string) {
    const child = await this.findAccessibleChild(userId, childId);
    return child;
  }

  async update(userId: string, childId: string, dto: UpdateChildDto) {
    await this.requireOwner(userId, childId);
    return this.prisma.child.update({
      where: { id: childId },
      data: {
        ...(dto.name && { name: dto.name }),
        ...(dto.birthDate !== undefined && {
          birthDate: dto.birthDate ? new Date(dto.birthDate) : null,
        }),
      },
    });
  }

  async remove(userId: string, childId: string) {
    await this.requireOwner(userId, childId);
    await this.prisma.child.delete({ where: { id: childId } });
  }

  // ── Sharing ────────────────────────────────────────────────────────────────

  async generateInvite(userId: string, childId: string) {
    await this.requireOwner(userId, childId);
    const code = this.randomCode(8);
    const invite = await this.prisma.childInvite.create({
      data: {
        code,
        childId,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
      },
    });
    return { code: invite.code, expiresAt: invite.expiresAt };
  }

  async acceptInvite(userId: string, code: string) {
    const invite = await this.prisma.childInvite.findUnique({ where: { code } });
    if (!invite) throw new NotFoundException('Invite code not found');
    if (invite.used) throw new BadRequestException('Invite code already used');
    if (invite.expiresAt && invite.expiresAt < new Date())
      throw new BadRequestException('Invite code expired');

    const child = await this.prisma.child.findUnique({ where: { id: invite.childId } });
    if (child?.ownerId === userId)
      throw new BadRequestException('You already own this child');

    const alreadyShared = await this.prisma.childShare.findUnique({
      where: { childId_userId: { childId: invite.childId, userId } },
    });
    if (alreadyShared) throw new BadRequestException('Child already shared with you');

    await this.prisma.$transaction([
      this.prisma.childShare.create({ data: { childId: invite.childId, userId } }),
      this.prisma.childInvite.update({ where: { code }, data: { used: true } }),
    ]);

    return this.prisma.child.findUnique({ where: { id: invite.childId } });
  }

  async listSharedUsers(userId: string, childId: string) {
    await this.requireOwner(userId, childId);
    return this.prisma.childShare.findMany({
      where: { childId },
      include: { user: { select: { id: true, email: true, name: true } } },
    });
  }

  async removeSharedUser(userId: string, childId: string, sharedUserId: string) {
    await this.requireOwner(userId, childId);
    await this.prisma.childShare.delete({
      where: { childId_userId: { childId, userId: sharedUserId } },
    });
  }

  // ── Child-scoped Events ────────────────────────────────────────────────────

  async listEvents(userId: string, childId: string) {
    await this.findAccessibleChild(userId, childId);
    return this.prisma.healthEvent.findMany({
      where: { childId },
      orderBy: { occurredAt: 'desc' },
    });
  }

  async createEvent(userId: string, childId: string, dto: CreateChildEventDto) {
    await this.findAccessibleChild(userId, childId);
    const child = await this.prisma.child.findUnique({ where: { id: childId } });
    return this.prisma.healthEvent.create({
      data: {
        type: dto.type,
        childId,
        childName: child!.name,
        notes: dto.notes,
        payload: dto.payload !== undefined ? (dto.payload as Prisma.InputJsonValue) : undefined,
        occurredAt: dto.occurredAt ? new Date(dto.occurredAt) : new Date(),
      },
    });
  }

  async updateEvent(
    userId: string,
    childId: string,
    eventId: string,
    dto: Partial<CreateChildEventDto>,
  ) {
    await this.findAccessibleChild(userId, childId);
    const event = await this.prisma.healthEvent.findFirst({ where: { id: eventId, childId } });
    if (!event) throw new NotFoundException(`Event ${eventId} not found`);
    return this.prisma.healthEvent.update({
      where: { id: eventId },
      data: {
        ...(dto.type && { type: dto.type }),
        ...(dto.notes !== undefined && { notes: dto.notes }),
        ...(dto.payload !== undefined && { payload: dto.payload as Prisma.InputJsonValue }),
        ...(dto.occurredAt && { occurredAt: new Date(dto.occurredAt) }),
      },
    });
  }

  async deleteEvent(userId: string, childId: string, eventId: string) {
    await this.findAccessibleChild(userId, childId);
    const event = await this.prisma.healthEvent.findFirst({ where: { id: eventId, childId } });
    if (!event) throw new NotFoundException(`Event ${eventId} not found`);
    await this.prisma.healthEvent.delete({ where: { id: eventId } });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  private async findAccessibleChild(userId: string, childId: string) {
    const child = await this.prisma.child.findUnique({
      where: { id: childId },
      include: { shares: { where: { userId } } },
    });
    if (!child) throw new NotFoundException(`Child ${childId} not found`);
    const isOwner = child.ownerId === userId;
    const isShared = child.shares.length > 0;
    if (!isOwner && !isShared) throw new ForbiddenException();
    return child;
  }

  private async requireOwner(userId: string, childId: string) {
    const child = await this.prisma.child.findUnique({ where: { id: childId } });
    if (!child) throw new NotFoundException(`Child ${childId} not found`);
    if (child.ownerId !== userId) throw new ForbiddenException();
    return child;
  }

  private randomCode(length: number): string {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return Array.from({ length }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
  }
}
