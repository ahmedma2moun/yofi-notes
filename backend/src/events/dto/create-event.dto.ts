import { IsString, IsEnum, IsOptional, IsObject, IsDateString } from 'class-validator';
import { EventType } from '@prisma/client';

export class CreateEventDto {
  @IsEnum(EventType)
  type: EventType;

  @IsString()
  childName: string;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsObject()
  payload?: Record<string, unknown>;

  @IsOptional()
  @IsDateString()
  occurredAt?: string;
}
