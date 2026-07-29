-- AlterTable
ALTER TABLE "Bookingrq" ADD COLUMN     "userId" INTEGER;

-- AddForeignKey
ALTER TABLE "Bookingrq" ADD CONSTRAINT "Bookingrq_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Login"("id") ON DELETE SET NULL ON UPDATE CASCADE;
