import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { ProductData } from '@/types';

const prisma = new PrismaClient();

// Получить все товары
export async function GET() {
  try {
    const products = await prisma.product.findMany();
    return NextResponse.json(products);
  } catch (error) {
    console.error('Error fetching products:', error);
    return NextResponse.json(
      { error: 'Could not fetch products' },
      { status: 500 }
    );
  }
}

// Создать новый товар
export async function POST(request: Request) {
  try {
    const data: ProductData = await request.json();
    
    const product = await prisma.product.create({
      data: {
        name: data.name,
        description: data.description,
        price: data.price,
        barcode: data.barcode,
        stock: data.stock,
      },
    });
    
    return NextResponse.json(product, { status: 201 });
  } catch (error) {
    console.error('Error creating product:', error);
    return NextResponse.json(
      { error: 'Could not create product' },
      { status: 500 }
    );
  }
} 