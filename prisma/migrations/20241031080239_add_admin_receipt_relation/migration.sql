-- CreateTable
CREATE TABLE "AdminBooking" (
    "id" SERIAL NOT NULL,
    "firstname" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "checkin" TIMESTAMP(3) NOT NULL,
    "checkout" TIMESTAMP(3) NOT NULL,
    "amount" INTEGER NOT NULL,
    "houseName" TEXT,
    "phonenumber" VARCHAR(15) NOT NULL,

    CONSTRAINT "AdminBooking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminReceipt" (
    "id" SERIAL NOT NULL,
    "adminBookingId" INTEGER NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdminReceipt_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "AdminReceipt" ADD CONSTRAINT "AdminReceipt_adminBookingId_fkey" FOREIGN KEY ("adminBookingId") REFERENCES "AdminBooking"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
