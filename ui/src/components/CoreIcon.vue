<script setup>
import { computed, inject } from 'vue'

// --- 1. Logic คงเดิม ---
const OUTER_RADIUS = 17
const OUTER_CIRCUMFERENCE = 2 * Math.PI * OUTER_RADIUS

const props = defineProps({
  type: { type: String, required: true },
  inner: { type: Number, default: 0 },
  outer: { type: Number, default: 0 },
  effectInside: { type: String, default: null },
  effectNext: { type: String, default: null },
  meta: { type: Object, default: null }
})

// [แก้ไข] เพิ่ม 'bleed' ลงไปในกลุ่มนี้ เพื่อให้แสดงแค่กล่องไอคอน (ไม่มีหลอด)
const SPECIAL_TYPES = new Set([
  'voice', 'temperature', 'temperature_value', 'messages',
  'horse_health', 'horse_stamina', 'horse_dirt', 'clean_stats', 'bleed'
])
const isSpecialType = computed(() => SPECIAL_TYPES.has(props.type))

const ICON_CLASS_MAP = { default: 'fa-solid fa-circle' }
const STAT_TYPES = new Set([])
const ICONLESS_TYPES = new Set(['messages', 'clean_stats'])

// คง 'bleed' ไว้ในรายการเด้ง (Pulse)
const PULSE_TYPES = new Set([
  'health', 'stamina', 'hunger', 'thirst', 'stress', 'clean_stats', 'bleed',
  'horse_health', 'horse_stamina', 'horse_dirt', 'messages'
])
const PULSE_EFFECTS = new Set(['starving', 'parched', 'stressed', 'drained', 'dirty', 'bleeding', 'horse_dirty', 'wounded', 'new_message'])

const ICON_IMAGE_MAP = {
  health: { default: 'cores/icon/heart.png' },
  stamina: { default: 'cores/icon/stamina.png' },
  hunger: { default: 'cores/icon/hunger.png' },
  thirst: { default: 'cores/icon/thirst.png' },
  stress: { default: 'cores/icon/brain.png' },
  messages: { default: 'cores/icon/letter.png' },
  voice: { default: 'cores/icon/talking.png' },
  /*temperature: {
    cold: 'cores/icon/temp_cold.png',
    hot: 'cores/icon/temp_hot.png',
    default: 'cores/icon/temp_hot.png'
  },*/
  temperature_value: {
    cold: 'cores/icon/temp_cold.png',
    hot: 'cores/icon/temp_hot.png',
    default: 'cores/icon/temp_cold.png'
  },
  clean_stats: { default: 'cores/icon/shower.png' },
  bleed: { default: 'cores/icon/bleed.png' },
  money: { default: 'cores/icon/money.png' },
  gold: { default: 'cores/icon/gold.png' },
  tokens: { default: 'cores/icon/token.png' },
  shield: { default: 'cores/icon/shield.png' },
  horse_health: { default: 'cores/icon/horse_health.png' },
  horse_stamina: { default: 'cores/icon/horse_stamina.png' },
  horse_dirt: { default: 'cores/icon/horse_dirty.png' }
}

const CORE_SPRITE_FOLDERS = {}

let rawBaseUrl = '/'
if (typeof import.meta !== 'undefined' && import.meta.env && typeof import.meta.env.BASE_URL === 'string' && import.meta.env.BASE_URL !== '') {
  rawBaseUrl = import.meta.env.BASE_URL
}
const BASE_URL = rawBaseUrl.endsWith('/') ? rawBaseUrl : `${rawBaseUrl}/`
const toAssetPath = (relativePath) => (typeof relativePath === 'string' && relativePath.length > 0) ? `${BASE_URL}${relativePath.replace(/^\/+/, '')}` : null

const paletteInjection = inject('palette', null)
const fallbackEntry = Object.freeze({
  accent: '#ffffff', icon: '#ffffff', background: '#0c1018', track: 'rgba(17, 24, 39, 0.85)', border: '#1f2937', shadow: '0 18px 28px rgba(8, 13, 23, 0.45)'
})

const paletteEntry = computed(() => {
  const source = paletteInjection?.value?.[props.type] || paletteInjection?.value?.default
  if (source && typeof source === 'object') {
    return {
      accent: source.accent ?? fallbackEntry.accent,
      icon: source.icon ?? fallbackEntry.icon,
      background: source.background ?? fallbackEntry.background,
      track: source.track ?? fallbackEntry.track,
      border: source.border ?? fallbackEntry.border,
      shadow: source.shadow ?? fallbackEntry.shadow
    }
  }
  return fallbackEntry
})

const normaliseEffectKey = (value) => (typeof value === 'string' ? value.toLowerCase() : null)

const resolveIconImage = () => {
  if (props.type === 'logo') {
    const logoSrc = props.meta?.logo
    if (!logoSrc) return null
    if (logoSrc.match(/^(http|https|nui|data):/)) return logoSrc
    return toAssetPath(logoSrc)
  }
  const entry = ICON_IMAGE_MAP[props.type]
  if (entry) {
    const insideKey = normaliseEffectKey(props.effectInside)
    if (insideKey && entry[insideKey]) return toAssetPath(entry[insideKey])
    if (entry.default) return toAssetPath(entry.default)
  }
  return null
}

const iconImage = computed(resolveIconImage)
const iconClass = computed(() => iconImage.value ? null : ICON_CLASS_MAP.default)

const toClampedPercent = (value) => {
  const numeric = Number(value)
  return Number.isFinite(numeric) ? Math.min(Math.max(numeric, 0), 100) : null
}

const voiceMeta = computed(() => {
  if (props.type !== 'voice' || !props.meta) return null
  const talking = props.meta.talking === true || props.meta.talking === 1 || props.meta.talking === 'true'
  const proximityPercent = toClampedPercent(props.meta.proximityPercent ?? props.meta.proximity)
  return { talking, proximityPercent }
})

const computeVoiceAccent = (percent) => {
  if (percent === null) return null
  const hue = Math.max(0, Math.min(120, 120 - (percent * 1.2)))
  return `hsl(${Math.round(hue)}, 85%, 60%)`
}

const accentColor = computed(() => {
  // [แก้ไข] ลบเงื่อนไขสี bleed ออก (เพราะไม่มีหลอดแล้ว)
  if (props.type === 'logo') return '#ffffff'
  if (props.type === 'voice' && voiceMeta.value?.talking) {
    return computeVoiceAccent(voiceMeta.value.proximityPercent) || paletteEntry.value.accent
  }
  return paletteEntry.value.accent
})

const trackColor = computed(() => {
  if (props.type === 'logo') return 'transparent'
  if (props.type === 'voice' && voiceMeta.value?.talking) return 'rgba(30, 58, 138, 0.55)'
  return paletteEntry.value.track
})

const backgroundColor = computed(() => {
  if (props.type === 'logo') return 'transparent'
  
  const bg = paletteEntry.value.background
  if (bg === '#0c1018') {
    return 'rgba(12, 16, 24, 0.5)' 
  }
  return bg
})

const borderColor = computed(() => paletteEntry.value.border)
const iconColor = computed(() => {
  if (props.type === 'voice' && voiceMeta.value?.talking) return '#f8fafc'
  if (props.type === 'logo') return '#ffffff'
  return paletteEntry.value.icon
})

const clampPercent = (value, max) => {
  const numeric = typeof value === 'number' ? value : 0
  const clamped = Math.max(0, Math.min(numeric, max))
  return (clamped / max) * 100
}

const outerPercent = computed(() => clampPercent(props.outer, 99))

const shouldPulse = computed(() => {
  if (!PULSE_TYPES.has(props.type)) return false
  const effect = typeof props.effectInside === 'string' ? props.effectInside.toLowerCase() : null
  if (effect && PULSE_EFFECTS.has(effect)) return true
  const percent = outerPercent.value
  if (percent === null) return false
  const thresholdValue = props.meta?.pulseThreshold ?? (props.type === 'clean_stats' ? 40 : 25)
  const threshold = Math.max(0, Math.min(Number(thresholdValue) || 0, 100))
  return percent <= threshold
})

const percentLabel = computed(() => {
  // [คงเดิม] ซ่อน Text สำหรับ bleed ด้วย
  const HIDDEN_TEXT_TYPES = new Set([
    'horse_health', 'horse_stamina', 'horse_dirt', 'clean_stats', 'bleed'
  ])
  if (HIDDEN_TEXT_TYPES.has(props.type)) return ''

  if (typeof props.effectNext === 'string' && props.effectNext.length > 0) return props.effectNext
  if (isSpecialType.value) return ''
  return `${Math.round(outerPercent.value)}%`
})

const coreSlotClasses = computed(() => {
  const classes = ['core-bar-item'] 
  if (typeof props.type === 'string') classes.push(`core-bar-${props.type}`)
  if (isSpecialType.value) classes.push('is-special-layout')
  return classes
})

const iconAnimClasses = computed(() => {
  const classes = []
  if (props.type === 'voice' && voiceMeta.value?.talking) classes.push('is-talking')
  if (shouldPulse.value) classes.push('is-pulsing')
  return classes
})
</script>

<template>
  <div 
    :class="coreSlotClasses" 
    :style="{
      '--accent-color': accentColor,
      '--icon-color': iconColor,
      '--track-color': trackColor,
      '--box-bg': backgroundColor,
      '--border-color': borderColor,
      '--glow-color': accentColor
    }"
  >
    <template v-if="isSpecialType">
      <div class="icon-box">
        <img 
          v-if="iconImage" 
          class="icon-img" 
          :class="iconAnimClasses"
          :src="iconImage" 
          :alt="type" 
          draggable="false" 
        />
        <i v-else-if="iconClass" class="icon-i" :class="iconClass"></i>
        
        <span v-if="percentLabel" class="floating-label">{{ percentLabel }}</span>
      </div>
    </template>

    <template v-else>
      <div class="icon-box">
        <img 
          v-if="iconImage" 
          class="icon-img" 
          :class="iconAnimClasses"
          :src="iconImage" 
          :alt="type" 
          draggable="false" 
        />
        <i v-else-if="iconClass" class="icon-i" :class="iconClass"></i>
      </div>

      <div class="bar-wrapper">
        <span class="bar-label">{{ percentLabel }}</span>
        <div class="progress-track">
          <div class="progress-fill" :style="{ width: `${outerPercent}%` }"></div>
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
/* --- Container หลัก --- */
.core-bar-item {
  position: relative;
  display: flex;
  align-items: flex-end;
  gap: 0.5rem;
  padding: 0.25rem;
  min-width: 9rem; 
  height: auto;
  user-select: none;
  transition: transform 0.2s;
}

.core-bar-item.is-special-layout {
  min-width: auto;
  width: auto;
}

/* Animation: Bounce/Pulse เฉพาะรูป */
.icon-img.is-pulsing,
.icon-img.is-talking {
  animation: softBounce 0.8s infinite ease-in-out;
}

@keyframes softBounce {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.15); }
}

/* --- ส่วนที่ 1: กล่องไอคอน --- */
.icon-box {
  width: 1.75rem;
  height: 1.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  background-color: var(--box-bg);
  border: none;
  border-radius: 2px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.3);
  flex-shrink: 0;
}

.icon-img {
  width: 60%;
  height: 60%;
  object-fit: contain;
  filter: drop-shadow(0 1px 2px rgba(0,0,0,0.5));
}

.icon-i {
  font-size: 1rem;
  color: var(--icon-color);
  text-shadow: 0 1px 2px rgba(0,0,0,0.7);
}

/* --- ตัวเลขลอยมุมขวาบน --- */
.floating-label {
  position: absolute;
  top: -0.4rem;
  right: -0.6rem; 
  background-color: transparent;
  font-family: 'Chineserok', sans-serif;
  font-size: 0.65rem;
  font-weight: 700;
  color: #fff;
  white-space: nowrap;
  text-shadow: 
    -1px -1px 0 #000,  
     1px -1px 0 #000,
    -1px  1px 0 #000,
     1px  1px 0 #000,
     0 0 4px rgba(0,0,0,0.8);
  pointer-events: none;
  z-index: 10;
}

/* --- Wrapper ฝั่งขวา --- */
.bar-wrapper {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  height: auto; 
  padding-bottom: 0;
}

/* --- ตัวเลข Percent --- */
.bar-label {
  font-family: 'Chineserok', sans-serif;
  font-size: 0.8rem;
  font-weight: 700;
  color: #f3f4f6;
  text-shadow: 1px 1px 0 #000, 0 0 4px rgba(0,0,0,0.8);
  margin-bottom: 0.4rem;
  text-align: left;
  line-height: 1;
}

/* --- รางหลอด --- */
.progress-track {
  width: 100%;
  height: 0.40rem;
  background-color: var(--track-color);
  border-radius: 4px;
  overflow: visible;
  position: relative;
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.5);
}

/* --- ไส้หลอด --- */
.progress-fill {
  height: 100%;
  background-color: var(--accent-color);
  border-radius: 4px;
  transition: width 0.3s ease-out, background-color 0.3s;
  position: relative;
  box-shadow: 0 0 8px var(--glow-color);
}
</style>