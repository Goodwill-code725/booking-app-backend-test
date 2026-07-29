/*
  Warnings:

  - You are about to drop the column `pictureUrl` on the `Bookingrq` table. All the data in the column will be lost.
  - You are about to drop the column `pictureUrl` on the `Requestresponse` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Bookingrq" DROP COLUMN "pictureUrl",
ADD COLUMN     "pictureUrls" TEXT[];

-- AlterTable
ALTER TABLE "Requestresponse" DROP COLUMN "pictureUrl",
ADD COLUMN     "pictureUrls" TEXT[];
