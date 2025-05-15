import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { LoginData } from '@/types';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

export async function POST(request: Request) {
  try {
    const data: LoginData = await request.json();
    
    // Ищем пользователя
    const user = await prisma.user.findUnique({
      where: {
        email: data.email,
      },
    });

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    // Проверяем пароль
    const validPassword = await bcrypt.compare(data.password, user.password);
    
    if (!validPassword) {
      return NextResponse.json(
        { error: 'Invalid password' },
        { status: 401 }
      );
    }

    // Не возвращаем пароль в ответе
    const { password, ...userWithoutPassword } = user;
    
    return NextResponse.json(userWithoutPassword);
  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json(
      { error: 'Could not log in' },
      { status: 500 }
    );
  }
} 