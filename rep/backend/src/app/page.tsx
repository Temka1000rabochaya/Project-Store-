import Image from "next/image";

export default function Home() {
  return (
    <main className="min-h-screen p-8 bg-black text-white">
      <h1 className="text-4xl font-bold mb-8">API умного магазина</h1>
      
      <div className="space-y-6">
        <section>
          <h2 className="text-2xl font-semibold mb-4">Доступные конечные точки:</h2>
          
          <div className="space-y-4">
            <div className="border border-gray-700 p-4 rounded-lg">
              <h3 className="text-xl font-medium mb-2">Аутентификация</h3>
              <ul className="list-disc list-inside space-y-2">
                <li>POST /api/auth/register - Регистрация нового пользователя</li>
                <li>POST /api/auth/login - Вход пользователя</li>
              </ul>
            </div>

            <div className="border border-gray-700 p-4 rounded-lg">
              <h3 className="text-xl font-medium mb-2">Продукция</h3>
              <ul className="list-disc list-inside space-y-2">
                <li>GET /api/products - Получить все продукты</li>
                <li>POST /api/products - Создать новый продукт</li>
              </ul>
            </div>

            <div className="border border-gray-700 p-4 rounded-lg">
              <h3 className="text-xl font-medium mb-2">Пример запроса (регистрация)</h3>
              <pre className="bg-gray-900 p-4 rounded text-green-400 font-mono">
{`POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "Test User"
}`}
              </pre>
            </div>
          </div>
        </section>
        </div>
      </main>
  );
}
