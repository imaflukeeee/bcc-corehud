<script setup>
// นำเข้า Component เมนูตั้งค่า
import SettingsMenu from './components/SettingsMenu.vue';
</script>

<template>
  <router-view />

  <SettingsMenu />
</template>

<style>
/* เรียกใช้ไฟล์ดีไซน์หลัก (ที่มี Tailwind และ CSS ใหม่รวมกัน) */
@import './assets/styles/main.css';

/* กำหนดขนาดให้ App เต็มจอ */
#app {
  width: 100%;
  height: 100%;
  overflow: hidden; /* ป้องกัน Scrollbar โผล่ในหน้าจอเกม */
}
</style>