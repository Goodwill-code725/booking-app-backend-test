-- AlterTable
ALTER TABLE "Requestresponse" ADD COLUMN     "bookingId" INTEGER;

-- AddForeignKey
ALTER TABLE "Requestresponse" ADD CONSTRAINT "Requestresponse_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Bookingrq"("id") ON DELETE SET NULL ON UPDATE CASCADE;
