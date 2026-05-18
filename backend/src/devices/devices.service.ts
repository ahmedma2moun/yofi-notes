import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDeviceDto } from './dto/register-device.dto';

@Injectable()
export class DevicesService {
  constructor(private prisma: PrismaService) {}

  async register(dto: RegisterDeviceDto) {
    return this.prisma.device.upsert({
      where: { fcmToken: dto.fcmToken },
      update: { updatedAt: new Date() },
      create: { fcmToken: dto.fcmToken },
    });
  }
}
