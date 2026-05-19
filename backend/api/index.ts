import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ExpressAdapter } from '@nestjs/platform-express';
import { AppModule } from '../src/app.module';
import * as express from 'express';

const server = express();

let app: ReturnType<typeof NestFactory.create> extends Promise<infer T> ? T : never;

async function bootstrap() {
  if (!app) {
    app = await NestFactory.create(AppModule, new ExpressAdapter(server));
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    app.enableCors();
    await app.init();
  }
  return server;
}

export default async function handler(req: any, res: any) {
  const expressApp = await bootstrap();
  expressApp(req, res);
}
