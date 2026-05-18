import { Injectable, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(private prisma: PrismaService) {}

  async broadcastEventNotification(event: {
    type: string;
    childName: string;
    summary: string;
  }) {
    const devices = await this.prisma.device.findMany();
    if (devices.length === 0) return;

    const tokens = devices.map((d) => d.fcmToken);

    const message: admin.messaging.MulticastMessage = {
      tokens,
      notification: {
        title: `Health Event — ${event.childName}`,
        body: event.summary,
      },
      data: {
        type: event.type,
        childName: event.childName,
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    const response = await admin.messaging().sendEachForMulticast(message);
    this.logger.log(
      `Notifications sent: ${response.successCount} ok, ${response.failureCount} failed`,
    );

    // Clean up invalid tokens
    response.responses.forEach(async (resp, idx) => {
      if (
        !resp.success &&
        resp.error?.code === 'messaging/registration-token-not-registered'
      ) {
        await this.prisma.device.delete({ where: { fcmToken: tokens[idx] } });
      }
    });
  }
}
