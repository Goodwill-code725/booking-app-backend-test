-- AlterTable
ALTER TABLE "Bookingrq" ALTER COLUMN "phonenumber_int" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "Receipt" ADD COLUMN     "requestId" INTEGER;

-- CreateTable
CREATE TABLE "Requestresponse" (
    "id" SERIAL NOT NULL,
    "firstname" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "checkin" TIMESTAMP(3) NOT NULL,
    "checkout" TIMESTAMP(3) NOT NULL,
    "amount" INTEGER NOT NULL,
    "houseName" TEXT,
    "phonenumber_int" BIGINT,
    "status" TEXT NOT NULL,
    "userId" INTEGER,

    CONSTRAINT "Requestresponse_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Requestresponse" ADD CONSTRAINT "Requestresponse_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Login"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Receipt" ADD CONSTRAINT "Receipt_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "Requestresponse"("id") ON DELETE SET NULL ON UPDATE CASCADE;
