import { IsString, IsOptional, IsDateString } from 'class-validator';

export class CreateChildDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;
}
