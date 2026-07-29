/*
  Warnings:

  - You are about to alter the column `phonenumber` on the `AdminBooking` table. The data in that column could be lost. The data in that column will be cast from `VarChar(15)` to `VarChar(11)`.
  - You are about to drop the column `phonenumber_int` on the `Bookingrq` table. All the data in the column will be lost.
  - You are about to drop the column `phonenumber_int` on the `Requestresponse` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "AdminBooking" ALTER COLUMN "firstname" DROP NOT NULL,
ALTER COLUMN "lastname" DROP NOT NULL,
ALTER COLUMN "checkin" DROP NOT NULL,
ALTER COLUMN "checkout" DROP NOT NULL,
ALTER COLUMN "amount" DROP NOT NULL,
ALTER COLUMN "phonenumber" DROP NOT NULL,
ALTER COLUMN "phonenumber" SET DATA TYPE VARCHAR(11);

-- AlterTable
ALTER TABLE "AdminReceipt" ALTER COLUMN "fileUrl" DROP NOT NULL,
ALTER COLUMN "uploadedAt" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Bookingrq" DROP COLUMN "phonenumber_int",
ADD COLUMN     "phonenumber" VARCHAR(11),
ALTER COLUMN "firstname" DROP NOT NULL,
ALTER COLUMN "lastname" DROP NOT NULL,
ALTER COLUMN "checkin" DROP NOT NULL,
ALTER COLUMN "checkout" DROP NOT NULL,
ALTER COLUMN "amount" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Receipt" ALTER COLUMN "fileUrl" DROP NOT NULL,
ALTER COLUMN "uploadedAt" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Requestresponse" DROP COLUMN "phonenumber_int",
ADD COLUMN     "phonenumber" VARCHAR(11),
ALTER COLUMN "firstname" DROP NOT NULL,
ALTER COLUMN "lastname" DROP NOT NULL,
ALTER COLUMN "checkin" DROP NOT NULL,
ALTER COLUMN "checkout" DROP NOT NULL,
ALTER COLUMN "amount" DROP NOT NULL,
ALTER COLUMN "status" DROP NOT NULL;
