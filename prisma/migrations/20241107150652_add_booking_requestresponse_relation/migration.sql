/*
  Warnings:

  - Made the column `firstname` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `lastname` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `checkin` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `checkout` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `amount` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `houseName` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `status` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `phonenumber` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `roomNumber` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `roomType` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.
  - Made the column `bookingId` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "Requestresponse" DROP CONSTRAINT "Requestresponse_bookingId_fkey";

-- AlterTable
ALTER TABLE "Requestresponse" ALTER COLUMN "firstname" SET NOT NULL,
ALTER COLUMN "lastname" SET NOT NULL,
ALTER COLUMN "checkin" SET NOT NULL,
ALTER COLUMN "checkout" SET NOT NULL,
ALTER COLUMN "amount" SET NOT NULL,
ALTER COLUMN "amount" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "houseName" SET NOT NULL,
ALTER COLUMN "status" SET NOT NULL,
ALTER COLUMN "phonenumber" SET NOT NULL,
ALTER COLUMN "phonenumber" SET DATA TYPE TEXT,
ALTER COLUMN "roomNumber" SET NOT NULL,
ALTER COLUMN "roomType" SET NOT NULL,
ALTER COLUMN "bookingId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Requestresponse" ADD CONSTRAINT "Requestresponse_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Bookingrq"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
