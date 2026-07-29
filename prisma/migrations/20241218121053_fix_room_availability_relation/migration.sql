-- CreateTable
CREATE TABLE "RoomAvailability" (
    "id" SERIAL NOT NULL,
    "roomType" TEXT NOT NULL,
    "availabilityStatus" TEXT NOT NULL,
    "lastUpdatedBy" INTEGER,
    "lastUpdatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RoomAvailability_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "RoomAvailability" ADD CONSTRAINT "RoomAvailability_lastUpdatedBy_fkey" FOREIGN KEY ("lastUpdatedBy") REFERENCES "AdminLogin"("id") ON DELETE SET NULL ON UPDATE CASCADE;
