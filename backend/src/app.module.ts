import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import * as admin from 'firebase-admin';
import { PrismaModule } from './prisma/prisma.module';
import { DevicesModule } from './devices/devices.module';
import { EventsModule } from './events/events.module';
import { NotificationsModule } from './notifications/notifications.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    DevicesModule,
    EventsModule,
    NotificationsModule,
  ],
})
export class AppModule {
  constructor() {
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
          privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
        }),
      });
    }
  }
}
