/*
  Warnings:

  - The `pictureUrl` column on the `AdminBooking` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "AdminBooking" DROP COLUMN "pictureUrl",
ADD COLUMN     "pictureUrl" TEXT[];
