/*
  Warnings:

  - Made the column `userId` on table `Requestresponse` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "Requestresponse" DROP CONSTRAINT "Requestresponse_userId_fkey";

-- AlterTable
ALTER TABLE "Requestresponse" ALTER COLUMN "userId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Requestresponse" ADD CONSTRAINT "Requestresponse_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Login"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
