<template>
  <div v-if="visible" class="settings-overlay">
    <div class="settings-window">
      
      <div class="sidebar">
        <div class="brand">
          <span>ตั้งค่า HUD</span>
        </div>
        
        <button 
          :class="['nav-btn', { active: currentTab === 'general' }]" 
          @click="currentTab = 'general'"
        >
          ทั่วไป
        </button>
        <button 
          :class="['nav-btn', { active: currentTab === 'palette' }]" 
          @click="currentTab = 'palette'"
        >
          ปรับแต่งสี
        </button>

        <div class="footer-actions">
          <button class="btn btn-save" @click="saveSettings">บันทึกการเปลี่ยนแปลง</button>
          <button class="btn btn-close" @click="closeMenu">ปิด</button>
        </div>
      </div>

      <div class="content-area">
        
        <div v-if="currentTab === 'general'">
          <h2 class="section-title">การตั้งค่าทั่วไป</h2>
          
          <div class="option-card">
            <div class="option-info">
              <h3>แสดง HUD</h3>
              <p>เปิดหรือปิดการแสดงผล HUD ทั้งหมด</p>
            </div>
            <button class="btn" @click="toggleHud">ซ่อน / แสดง</button>
          </div>

          <div class="option-card" style="margin-top:10px;">
            <div class="option-info">
              <h3>แก้ไขตำแหน่ง</h3>
              <p>ลากและย้ายตำแหน่งองค์ประกอบของ HUD</p>
            </div>
            <button class="btn" @click="editLayout">แก้ไขตำแหน่ง</button>
          </div>

          <div class="option-card" style="margin-top:10px;">
            <div class="option-info">
              <h3>รีเซ็ตตำแหน่ง</h3>
              <p>คืนค่าตำแหน่ง HUD เป็นค่าดั้งเดิม</p>
            </div>
            <button class="btn" @click="resetLayout">รีเซ็ต</button>
          </div>

          <div class="option-card" style="margin-top:10px;">
            <div class="option-info">
              <h3>ฮีลตัวละคร</h3>
              <p>ฟื้นฟูพลังชีวิต/สแตมิน่า (เฉพาะแอดมิน)</p>
            </div>
            <button class="btn" @click="healPlayer">ฮีลตัวฉัน</button>
          </div>
        </div>

        <div v-if="currentTab === 'palette'">
          <h2 class="section-title">การปรับแต่งสี</h2>
          <div class="palette-grid">
            <div v-for="(val, key) in paletteData" :key="key" class="color-control">
              <div class="color-header">
                <span style="text-transform: capitalize; color:#fff;">{{ getLabel(key) }}</span>
                <div class="color-preview" :style="{ background: getPreviewColor(val.hue, val.saturation) }"></div>
              </div>
              
              <div class="slider-row">
                <span style="width:50px;">เฉดสี</span> <input type="range" min="0" max="360" v-model.number="val.hue" @input="updatePreview(key)">
                <span style="width:30px; text-align:right;">{{ val.hue }}</span>
              </div>
              
              <div class="slider-row">
                <span style="width:70px;">ความเข้ม</span> <input type="range" min="0" max="100" v-model.number="val.saturation" @input="updatePreview(key)">
                <span style="width:30px; text-align:right;">{{ val.saturation }}</span>
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>
  </div>
</template>

<script>
const post = (endpoint, data) => {
  if (window.GetParentResourceName) {
    fetch(`https://${window.GetParentResourceName()}/${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data || {})
    }).catch(() => {});
  }
};

export default {
  data() {
    return {
      visible: false,
      currentTab: 'general',
      paletteData: {}
    };
  },
  mounted() {
    window.addEventListener('message', this.onMessage);
    document.addEventListener('keydown', this.onKey);
  },
  beforeUnmount() {
    window.removeEventListener('message', this.onMessage);
    document.removeEventListener('keydown', this.onKey);
  },
  methods: {
    // 👇 ฟังก์ชันแปลภาษา (คุณสามารถแก้ไขคำแปลในนี้ได้เลย)
    getLabel(key) {
      const labels = {
        'health': 'พลังชีวิต',
        'stamina': 'สเตมิน่า',
        'hunger': 'ความหิว',
        'thirst': 'กระหายน้ำ',
        'stress': 'ความเครียด',
        'clean_stats': 'ความสะอาด',
        'temperature': 'อุณหภูมิ',
        'horse_health': 'พลังชีวิตม้า',
        'horse_stamina': 'สเตมิน่าม้า',
        'horse_dirt': 'ความสกปรกม้า',
        'voice': 'ไมโครโฟน',
        'messages': 'จดหมาย'
      };
      return labels[key] || key;
    },

    onMessage(event) {
      const data = event.data;
      if (data.type === 'open_settings') {
        this.visible = true;
        if (data.palette) {
          this.paletteData = JSON.parse(JSON.stringify(data.palette));
        }
      }
      if (data.type === 'close_settings') {
        this.visible = false;
      }
    },
    onKey(e) {
      if (this.visible && (e.key === 'Escape')) {
        this.closeMenu();
      }
    },
    closeMenu() {
      this.visible = false;
      post('closeSettings');
    },
    toggleHud() { post('toggleHudCommand'); },
    editLayout() {
      this.closeMenu();
      post('setLayoutEditing', { editing: true });
    },
    resetLayout() { post('resetLayoutCommand'); },
    healPlayer() { post('healPlayerCommand'); },
    saveSettings() {
      post('savePalette', { snapshot: this.paletteData });
      this.closeMenu();
    },
    updatePreview(key) {
      post('previewPalette', { 
         key: key, 
         hue: this.paletteData[key].hue, 
         saturation: this.paletteData[key].saturation 
      });
    },
    getPreviewColor(h, s) {
      return `hsl(${h}, ${s}%, 50%)`;
    }
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Pridi:wght@300;400;500;600;700&display=swap');

.settings-overlay, 
.settings-overlay * {
  font-family: 'Pridi', serif !important;
}
</style>