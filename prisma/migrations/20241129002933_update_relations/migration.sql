/*
  Warnings:

  - You are about to drop the `Receipt` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Receipt" DROP CONSTRAINT "Receipt_bookingId_fkey";

-- DropForeignKey
ALTER TABLE "Receipt" DROP CONSTRAINT "Receipt_requestId_fkey";

-- DropForeignKey
ALTER TABLE "Requestresponse" DROP CONSTRAINT "Requestresponse_bookingId_fkey";

-- AlterTable
ALTER TABLE "Requestresponse" ALTER COLUMN "bookingId" DROP NOT NULL;

-- DropTable
DROP TABLE "Receipt";

-- AddForeignKey
ALTER TABLE "Requestresponse" ADD CONSTRAINT "Requestresponse_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Bookingrq"("id") ON DELETE SET NULL ON UPDATE CASCADE;
