import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { ChildrenController } from './children.controller';
import { ChildrenService } from './children.service';

@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [ChildrenController],
  providers: [ChildrenService],
})
export class ChildrenModule {}
