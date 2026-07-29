/*
  Warnings:

  - You are about to drop the column `lastUpdatedBy` on the `RoomAvailability` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "RoomAvailability" DROP CONSTRAINT "RoomAvailability_lastUpdatedBy_fkey";

-- AlterTable
ALTER TABLE "RoomAvailability" DROP COLUMN "lastUpdatedBy";
