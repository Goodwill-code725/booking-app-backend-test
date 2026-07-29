/*
  Warnings:

  - You are about to alter the column `amount` on the `Requestresponse` table. The data in that column could be lost. The data in that column will be cast from `DoublePrecision` to `Integer`.
  - You are about to alter the column `phonenumber` on the `Requestresponse` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(11)`.
  - A unique constraint covering the columns `[bookingId]` on the table `Requestresponse` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Requestresponse" DROP CONSTRAINT "Requestresponse_userId_fkey";

-- AlterTable
ALTER TABLE "Requestresponse" ALTER COLUMN "firstname" DROP NOT NULL,
ALTER COLUMN "lastname" DROP NOT NULL,
ALTER COLUMN "checkin" DROP NOT NULL,
ALTER COLUMN "checkout" DROP NOT NULL,
ALTER COLUMN "amount" DROP NOT NULL,
ALTER COLUMN "amount" SET DATA TYPE INTEGER,
ALTER COLUMN "houseName" DROP NOT NULL,
ALTER COLUMN "status" DROP NOT NULL,
ALTER COLUMN "userId" DROP NOT NULL,
ALTER COLUMN "phonenumber" DROP NOT NULL,
ALTER COLUMN "phonenumber" SET DATA TYPE VARCHAR(11),
ALTER COLUMN "roomNumber" DROP NOT NULL,
ALTER COLUMN "roomType" DROP NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Requestresponse_bookingId_key" ON "Requestresponse"("bookingId");

-- AddForeignKey
ALTER TABLE "Requestresponse" ADD CONSTRAINT "Requestresponse_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Login"("id") ON DELETE SET NULL ON UPDATE CASCADE;
