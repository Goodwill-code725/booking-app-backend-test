/*
  Warnings:

  - You are about to drop the `AdminReceipt` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "AdminReceipt" DROP CONSTRAINT "AdminReceipt_adminBookingId_fkey";

-- AlterTable
ALTER TABLE "AdminBooking" ADD COLUMN     "pictureUrl" TEXT;

-- DropTable
DROP TABLE "AdminReceipt";
