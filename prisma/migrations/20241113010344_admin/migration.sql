-- CreateTable
CREATE TABLE "AdminLogin" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdminLogin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminBooking" (
    "id" SERIAL NOT NULL,
    "firstname" TEXT,
    "lastname" TEXT,
    "checkin" TIMESTAMP(3),
    "checkout" TIMESTAMP(3),
    "amount" INTEGER,
    "houseName" TEXT,
    "phonenumber" VARCHAR(11),
    "roomType" TEXT,
    "adminId" INTEGER NOT NULL,

    CONSTRAINT "AdminBooking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminReceipt" (
    "id" SERIAL NOT NULL,
    "adminBookingId" INTEGER NOT NULL,
    "fileUrl" TEXT,
    "uploadedAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdminReceipt_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AdminLogin_username_key" ON "AdminLogin"("username");

-- AddForeignKey
ALTER TABLE "AdminBooking" ADD CONSTRAINT "AdminBooking_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "AdminLogin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminReceipt" ADD CONSTRAINT "AdminReceipt_adminBookingId_fkey" FOREIGN KEY ("adminBookingId") REFERENCES "AdminBooking"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
