import { Controller, Post, Body } from '@nestjs/common';
import { DevicesService } from './devices.service';
import { RegisterDeviceDto } from './dto/register-device.dto';

@Controller('devices')
export class DevicesController {
  constructor(private devicesService: DevicesService) {}

  @Post('register')
  register(@Body() dto: RegisterDeviceDto) {
    return this.devicesService.register(dto);
  }
}
