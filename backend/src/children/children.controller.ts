import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  HttpCode,
  HttpStatus,
  UseGuards,
  Req,
} from '@nestjs/common';
import { Request } from 'express';
import { JwtGuard, JwtPayload } from '../auth/jwt.guard';
import { ChildrenService } from './children.service';
import { CreateChildDto } from './dto/create-child.dto';
import { UpdateChildDto } from './dto/update-child.dto';
import { CreateChildEventDto } from './dto/create-child-event.dto';

@UseGuards(JwtGuard)
@Controller('children')
export class ChildrenController {
  constructor(private childrenService: ChildrenService) {}

  private userId(req: Request): string {
    return (req['user'] as JwtPayload).sub;
  }

  // ── Children CRUD ──────────────────────────────────────────────────────────

  @Get()
  findAll(@Req() req: Request) {
    return this.childrenService.findAll(this.userId(req));
  }

  @Post()
  create(@Req() req: Request, @Body() dto: CreateChildDto) {
    return this.childrenService.create(this.userId(req), dto);
  }

  @Get(':id')
  findOne(@Req() req: Request, @Param('id') id: string) {
    return this.childrenService.findOne(this.userId(req), id);
  }

  @Patch(':id')
  update(@Req() req: Request, @Param('id') id: string, @Body() dto: UpdateChildDto) {
    return this.childrenService.update(this.userId(req), id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Req() req: Request, @Param('id') id: string) {
    return this.childrenService.remove(this.userId(req), id);
  }

  // ── Sharing ────────────────────────────────────────────────────────────────

  @Post(':id/invite')
  generateInvite(@Req() req: Request, @Param('id') id: string) {
    return this.childrenService.generateInvite(this.userId(req), id);
  }

  @Post('accept-invite')
  acceptInvite(@Req() req: Request, @Body('code') code: string) {
    return this.childrenService.acceptInvite(this.userId(req), code);
  }

  @Get(':id/shared-users')
  listSharedUsers(@Req() req: Request, @Param('id') id: string) {
    return this.childrenService.listSharedUsers(this.userId(req), id);
  }

  @Delete(':id/shared-users/:userId')
  @HttpCode(HttpStatus.NO_CONTENT)
  removeSharedUser(
    @Req() req: Request,
    @Param('id') id: string,
    @Param('userId') sharedUserId: string,
  ) {
    return this.childrenService.removeSharedUser(this.userId(req), id, sharedUserId);
  }

  // ── Child-scoped Events ────────────────────────────────────────────────────

  @Get(':childId/events')
  listEvents(@Req() req: Request, @Param('childId') childId: string) {
    return this.childrenService.listEvents(this.userId(req), childId);
  }

  @Post(':childId/events')
  createEvent(
    @Req() req: Request,
    @Param('childId') childId: string,
    @Body() dto: CreateChildEventDto,
  ) {
    return this.childrenService.createEvent(this.userId(req), childId, dto);
  }

  @Patch(':childId/events/:eventId')
  updateEvent(
    @Req() req: Request,
    @Param('childId') childId: string,
    @Param('eventId') eventId: string,
    @Body() dto: Partial<CreateChildEventDto>,
  ) {
    return this.childrenService.updateEvent(this.userId(req), childId, eventId, dto);
  }

  @Delete(':childId/events/:eventId')
  @HttpCode(HttpStatus.NO_CONTENT)
  deleteEvent(
    @Req() req: Request,
    @Param('childId') childId: string,
    @Param('eventId') eventId: string,
  ) {
    return this.childrenService.deleteEvent(this.userId(req), childId, eventId);
  }
}
