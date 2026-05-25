import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { EventsModule } from './events/events.module';
import { AuthModule } from './auth/auth.module';
import { ChildrenModule } from './children/children.module';
import { PrivacyController } from './privacy/privacy.controller';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    EventsModule,
    AuthModule,
    ChildrenModule,
  ],
  controllers: [PrivacyController],
})
export class AppModule {}
