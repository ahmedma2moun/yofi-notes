import { Controller, Post, Patch, Body, HttpCode, HttpStatus, UseGuards, Req } from '@nestjs/common';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { JwtGuard, JwtPayload } from './jwt.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @UseGuards(JwtGuard)
  @Patch('password')
  @HttpCode(HttpStatus.NO_CONTENT)
  changePassword(@Req() req: Request, @Body() dto: ChangePasswordDto) {
    const userId = (req['user'] as JwtPayload).sub;
    return this.authService.changePassword(userId, dto);
  }
}
