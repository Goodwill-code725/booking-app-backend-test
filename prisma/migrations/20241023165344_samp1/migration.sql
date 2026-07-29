-- CreateTable
CREATE TABLE "Bookingrq" (
    "id" SERIAL NOT NULL,
    "firstname" VARCHAR(50) NOT NULL,
    "lastname" VARCHAR(50) NOT NULL,
    "checkin" TIMESTAMP(3) NOT NULL,
    "checkout" TIMESTAMP(3) NOT NULL,
    "phonenumber" VARCHAR(15) NOT NULL,
    "amount" INTEGER NOT NULL,

    CONSTRAINT "Bookingrq_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Receipt" (
    "id" SERIAL NOT NULL,
    "bookingId" INTEGER NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Receipt_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Receipt" ADD CONSTRAINT "Receipt_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Bookingrq"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
