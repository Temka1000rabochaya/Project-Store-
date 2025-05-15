import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { UserData } from '@/types';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

export async function POST(request: Request) {
  try {
    const data: UserData = await request.json();
    
    // Хешируем пароль
    const hashedPassword = await bcrypt.hash(data.password, 10);
    
    // Создаем пользователя
    const user = await prisma.user.create({
      data: {
        email: data.email,
        password: hashedPassword,
        name: data.name,
      },
    });

    // Не возвращаем пароль в ответе
    const { password, ...userWithoutPassword } = user;
    
    return NextResponse.json(userWithoutPassword, { status: 201 });
  } catch (error) {
    console.error('Registration error:', error);
    return NextResponse.json(
      { error: 'Could not register user' },
      { status: 500 }
    );
  }
} 