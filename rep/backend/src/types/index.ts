export interface UserData {
  email: string;
  password: string;
  name: string;
}

export interface ProductData {
  name: string;
  description: string;
  price: number;
  barcode: string;
  stock: number;
}

export interface OrderItemData {
  productId: number;
  quantity: number;
}

export interface OrderData {
  items: OrderItemData[];
}

export interface LoginData {
  email: string;
  password: string;
} 