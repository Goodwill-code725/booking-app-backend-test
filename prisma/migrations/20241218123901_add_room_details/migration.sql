/*
  Warnings:

  - You are about to drop the column `availabilityStatus` on the `RoomAvailability` table. All the data in the column will be lost.
  - You are about to drop the column `lastUpdatedAt` on the `RoomAvailability` table. All the data in the column will be lost.
  - Added the required column `location` to the `RoomAvailability` table without a default value. This is not possible if the table is not empty.
  - Added the required column `roomNumber` to the `RoomAvailability` table without a default value. This is not possible if the table is not empty.
  - Added the required column `status` to the `RoomAvailability` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "RoomAvailability" DROP COLUMN "availabilityStatus",
DROP COLUMN "lastUpdatedAt",
ADD COLUMN     "location" TEXT NOT NULL,
ADD COLUMN     "roomNumber" TEXT NOT NULL,
ADD COLUMN     "status" TEXT NOT NULL;
