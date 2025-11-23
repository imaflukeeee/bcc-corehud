import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  base: './', // สำคัญ: ให้ใช้ path แบบ relative
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  build: {
    outDir: '../web',    // [สำคัญ] สั่งให้ Build ไปที่โฟลเดอร์ web ด้านนอกโฟลเดอร์ ui
    emptyOutDir: true,   // [แนะนำ] ลบไฟล์ในโฟลเดอร์ web ทิ้งทุกครั้งก่อน Build ใหม่ (กันไฟล์เก่าค้าง)
    chunkSizeWarningLimit: 1000
  }
})