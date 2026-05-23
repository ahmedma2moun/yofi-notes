import { IsString, IsOptional, IsDateString } from 'class-validator';

export class UpdateChildDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;
}
