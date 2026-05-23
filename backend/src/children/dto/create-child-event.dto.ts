import { IsString, IsEnum, IsOptional, IsObject, IsDateString } from 'class-validator';
import { EventType } from '@prisma/client';

export class CreateChildEventDto {
  @IsEnum(EventType)
  type: EventType;

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
