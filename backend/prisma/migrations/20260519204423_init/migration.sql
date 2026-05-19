-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('MEDICINE', 'TEMPERATURE', 'CUSTOM');

-- CreateTable
CREATE TABLE "HealthEvent" (
    "id" TEXT NOT NULL,
    "type" "EventType" NOT NULL,
    "childName" TEXT NOT NULL,
    "notes" TEXT,
    "occurredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "payload" JSONB,

    CONSTRAINT "HealthEvent_pkey" PRIMARY KEY ("id")
);
