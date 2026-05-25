// MyKids — Screen designs (React components)
// All 10 screens specified in DESIGN_SPEC.md, rendered at iPhone dimensions.

const MK = {
  // Brand
  primary: '#4A90D9',
  primaryLight: '#EBF4FF',
  // Surfaces
  surface: '#FFFFFF',
  surfaceSecondary: '#F2F2F7',
  groupedBg: '#F2F2F7',
  // Text
  textPrimary: '#1C1C1E',
  textSecondary: '#8E8E93',
  textTertiary: '#C7C7CC',
  // Semantic
  destructive: '#FF3B30',
  medicine: '#007AFF',
  temperature: '#FF9500',
  custom: '#AF52DE',
  success: '#34C759',
  // Separator
  separator: 'rgba(60,60,67,0.18)',
  separatorOpaque: '#C6C6C8',
  font: '-apple-system, "SF Pro Text", "SF Pro", system-ui, sans-serif',
  mono: '"SF Mono", ui-monospace, "Menlo", monospace',
};

// ──────────────────────────────────────────────────────────────────────
// Shared chrome primitives
// ──────────────────────────────────────────────────────────────────────

function StatusBar({ dark = false, time = '9:41' }) {
  const c = dark ? '#fff' : '#000';
  return (
    <div style={{
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '21px 32px 0', height: 54, position: 'relative', zIndex: 20,
      boxSizing: 'border-box', fontFamily: MK.font,
    }}>
      <span style={{ fontWeight: 600, fontSize: 17, color: c, letterSpacing: -0.2 }}>{time}</span>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginRight: -4 }}>
        <svg width="18" height="11" viewBox="0 0 18 11">
          <rect x="0" y="6" width="3" height="5" rx="0.6" fill={c}/>
          <rect x="4.5" y="4" width="3" height="7" rx="0.6" fill={c}/>
          <rect x="9" y="2" width="3" height="9" rx="0.6" fill={c}/>
          <rect x="13.5" y="0" width="3" height="11" rx="0.6" fill={c}/>
        </svg>
        <svg width="16" height="11" viewBox="0 0 17 12">
          <path d="M8.5 3.2C10.8 3.2 12.9 4.1 14.4 5.6L15.5 4.5C13.7 2.7 11.2 1.5 8.5 1.5C5.8 1.5 3.3 2.7 1.5 4.5L2.6 5.6C4.1 4.1 6.2 3.2 8.5 3.2Z" fill={c}/>
          <path d="M8.5 6.8C9.9 6.8 11.1 7.3 12 8.2L13.1 7.1C11.8 5.9 10.2 5.1 8.5 5.1C6.8 5.1 5.2 5.9 3.9 7.1L5 8.2C5.9 7.3 7.1 6.8 8.5 6.8Z" fill={c}/>
          <circle cx="8.5" cy="10.5" r="1.5" fill={c}/>
        </svg>
        <svg width="25" height="12" viewBox="0 0 27 13">
          <rect x="0.5" y="0.5" width="23" height="12" rx="3.5" stroke={c} strokeOpacity="0.35" fill="none"/>
          <rect x="2" y="2" width="20" height="9" rx="2" fill={c}/>
          <path d="M25 4.5V8.5C25.8 8.2 26.5 7.2 26.5 6.5C26.5 5.8 25.8 4.8 25 4.5Z" fill={c} fillOpacity="0.4"/>
        </svg>
      </div>
    </div>
  );
}

function HomeIndicator() {
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0,
      height: 34, display: 'flex', justifyContent: 'center', alignItems: 'flex-end',
      paddingBottom: 8, pointerEvents: 'none', zIndex: 60,
    }}>
      <div style={{ width: 134, height: 5, borderRadius: 100, background: '#000' }} />
    </div>
  );
}

function Phone({ children, bg = MK.groupedBg, dark = false }) {
  return (
    <div style={{
      width: 393, height: 852, borderRadius: 50, overflow: 'hidden',
      position: 'relative', background: bg, fontFamily: MK.font,
      WebkitFontSmoothing: 'antialiased',
      boxShadow: '0 30px 60px rgba(0,0,0,0.15), 0 0 0 1px rgba(0,0,0,0.08)',
    }}>
      {/* dynamic island */}
      <div style={{
        position: 'absolute', top: 11, left: '50%', transform: 'translateX(-50%)',
        width: 124, height: 36, borderRadius: 22, background: '#000', zIndex: 50,
      }} />
      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column' }}>
        <StatusBar dark={dark} />
        <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>{children}</div>
      </div>
      <HomeIndicator />
    </div>
  );
}

// Simple "tab bar" along the bottom (above home indicator)
function TabBar({ active = 'children' }) {
  const Tab = ({ id, label, icon }) => {
    const isActive = active === id;
    const c = isActive ? MK.primary : MK.textSecondary;
    return (
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3, paddingTop: 6 }}>
        <div style={{ width: 26, height: 26, color: c, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{icon}</div>
        <div style={{ fontSize: 10, fontWeight: 500, color: c, letterSpacing: 0.1 }}>{label}</div>
      </div>
    );
  };
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0,
      height: 83, paddingBottom: 22, background: 'rgba(249,249,249,0.94)',
      backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)',
      borderTop: `0.5px solid ${MK.separator}`, display: 'flex',
    }}>
      <Tab id="children" label="Children" icon={
        <svg width="24" height="22" viewBox="0 0 24 22" fill="none">
          <circle cx="7" cy="5" r="3" fill="currentColor"/>
          <path d="M2 20c0-2.8 2.2-5 5-5s5 2.2 5 5" stroke="currentColor" strokeWidth="2" strokeLinecap="round" fill="none"/>
          <circle cx="17" cy="8" r="2.4" fill="currentColor"/>
          <path d="M13 20c0-2.2 1.8-4 4-4s4 1.8 4 4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" fill="none"/>
          <path d="M10 13l3-2" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/>
        </svg>
      }/>
      <Tab id="settings" label="Settings" icon={
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="2"/>
          <path d="M12 1.5l1.3 2.5 2.7-.5.6 2.7 2.7.6-.5 2.7 2.5 1.3-1.4 2.4 1.4 2.4-2.5 1.3.5 2.7-2.7.6-.6 2.7-2.7-.5L12 22.5l-1.3-2.5-2.7.5-.6-2.7-2.7-.6.5-2.7-2.5-1.3 1.4-2.4-1.4-2.4 2.5-1.3-.5-2.7 2.7-.6.6-2.7 2.7.5L12 1.5z" stroke="currentColor" strokeWidth="1.6" strokeLinejoin="round"/>
        </svg>
      }/>
    </div>
  );
}

// SF-style icons (originals — simple geometry)
const Icons = {
  family: (size = 60, color = MK.primary) => (
    <svg width={size} height={size * 0.85} viewBox="0 0 100 85" fill="none">
      {/* adult */}
      <circle cx="28" cy="18" r="10" fill={color}/>
      <path d="M14 50c0-7.7 6.3-14 14-14s14 6.3 14 14v18a4 4 0 01-4 4h-20a4 4 0 01-4-4V50z" fill={color}/>
      {/* child */}
      <circle cx="70" cy="28" r="8" fill={color} fillOpacity="0.75"/>
      <path d="M58 56c0-6.6 5.4-12 12-12s12 5.4 12 12v12a4 4 0 01-4 4H62a4 4 0 01-4-4V56z" fill={color} fillOpacity="0.75"/>
      {/* holding hands line */}
      <path d="M42 60 L58 60" stroke={color} strokeWidth="3.5" strokeLinecap="round" opacity="0.6"/>
    </svg>
  ),
  pill: (size = 22, color = MK.medicine) => (
    <svg width={size} height={size} viewBox="0 0 24 24">
      <rect x="2" y="8" width="20" height="8" rx="4" fill={color}/>
      <rect x="2" y="8" width="10" height="8" rx="4" fill={color} fillOpacity="0.7"/>
      <rect x="11.4" y="8" width="1.2" height="8" fill="#fff" fillOpacity="0.9"/>
    </svg>
  ),
  thermometer: (size = 22, color = MK.temperature) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M12 4a3 3 0 016 0v9.5a4.5 4.5 0 11-6 0V4z" stroke={color} strokeWidth="2"/>
      <circle cx="15" cy="17" r="2.6" fill={color}/>
      <path d="M15 6v8" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
  star: (size = 22, color = MK.custom) => (
    <svg width={size} height={size} viewBox="0 0 24 24">
      <path d="M12 2.5l2.95 6.5 7.05.7-5.3 4.85L18.2 21.5 12 18l-6.2 3.5L7.3 14.55 2 9.7l7.05-.7L12 2.5z" fill={color}/>
    </svg>
  ),
  plus: (size = 22, color = MK.primary) => (
    <svg width={size} height={size} viewBox="0 0 24 24">
      <path d="M12 5v14M5 12h14" stroke={color} strokeWidth="2.4" strokeLinecap="round"/>
    </svg>
  ),
  chevronDown: (size = 14, color = MK.textSecondary) => (
    <svg width={size} height={size} viewBox="0 0 14 14"><path d="M3 5l4 4 4-4" stroke={color} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
  ),
  chevronRight: (size = 12, color = MK.textTertiary) => (
    <svg width={size} height={(size * 14) / 8} viewBox="0 0 8 14"><path d="M1 1l6 6-6 6" stroke={color} strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
  ),
  chevronLeft: (size = 16, color = MK.primary) => (
    <svg width={size * 0.6} height={size} viewBox="0 0 10 16"><path d="M9 1L1 8l8 7" stroke={color} strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>
  ),
  ellipsis: (size = 18, color = MK.textSecondary) => (
    <svg width={size} height={size / 4} viewBox="0 0 18 4"><circle cx="2" cy="2" r="2" fill={color}/><circle cx="9" cy="2" r="2" fill={color}/><circle cx="16" cy="2" r="2" fill={color}/></svg>
  ),
  personPlus: (size = 22, color = MK.primary) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="9" cy="8" r="4" stroke={color} strokeWidth="2"/>
      <path d="M2 21c0-3.9 3.1-7 7-7s7 3.1 7 7" stroke={color} strokeWidth="2" strokeLinecap="round"/>
      <path d="M19 8v6M16 11h6" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
  share: (size = 22, color = MK.primary) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M12 3v13M12 3l-4 4M12 3l4 4" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
      <path d="M5 12v7a2 2 0 002 2h10a2 2 0 002-2v-7" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
  copy: (size = 18, color = MK.primary) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="8" y="8" width="13" height="13" rx="2.5" stroke={color} strokeWidth="2"/>
      <path d="M16 8V5a2 2 0 00-2-2H5a2 2 0 00-2 2v9a2 2 0 002 2h3" stroke={color} strokeWidth="2"/>
    </svg>
  ),
  tray: (size = 48, color = MK.textTertiary) => (
    <svg width={size} height={size * 0.8} viewBox="0 0 60 48" fill="none">
      <path d="M5 28l9-22h32l9 22" stroke={color} strokeWidth="2.4"/>
      <path d="M5 28h13l3 6h18l3-6h13v12a4 4 0 01-4 4H9a4 4 0 01-4-4V28z" stroke={color} strokeWidth="2.4" strokeLinejoin="round"/>
    </svg>
  ),
  linkBadgePlus: (size = 22, color = '#fff') => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M10 14a4 4 0 010-6l2-2a4 4 0 016 6l-1 1" stroke={color} strokeWidth="2" strokeLinecap="round"/>
      <path d="M14 10a4 4 0 010 6l-2 2a4 4 0 01-6-6l1-1" stroke={color} strokeWidth="2" strokeLinecap="round"/>
      <circle cx="19" cy="19" r="4" fill={color}/>
      <path d="M19 17.5v3M17.5 19h3" stroke={MK.primary} strokeWidth="1.6" strokeLinecap="round"/>
    </svg>
  ),
  check: (size = 18, color = MK.success) => (
    <svg width={size} height={size} viewBox="0 0 18 18" fill="none"><path d="M3 9.5l4 4 8-9" stroke={color} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"/></svg>
  ),
  signOut: (size = 22, color = MK.destructive) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M10 3H5a2 2 0 00-2 2v14a2 2 0 002 2h5" stroke={color} strokeWidth="2" strokeLinecap="round"/>
      <path d="M15 8l5 4-5 4M20 12H9" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  ),
  person: (size = 22, color = MK.textSecondary) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="8" r="4" stroke={color} strokeWidth="2"/>
      <path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    </svg>
  ),
};

// ──────────────────────────────────────────────────────────────────────
// Helpers
// ──────────────────────────────────────────────────────────────────────

function NavBar({ leading, title, trailing, largeTitle = true, dark = false, bg }) {
  return (
    <div style={{ background: bg || 'transparent', paddingTop: 4 }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 16px', height: 44 }}>
        <div style={{ minWidth: 60, display: 'flex', alignItems: 'center', gap: 4, color: MK.primary, fontSize: 17 }}>{leading}</div>
        {!largeTitle && <div style={{ fontSize: 17, fontWeight: 600, color: dark ? '#fff' : MK.textPrimary }}>{title}</div>}
        <div style={{ minWidth: 60, display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 12, color: MK.primary, fontSize: 17 }}>{trailing}</div>
      </div>
      {largeTitle && (
        <div style={{ padding: '6px 20px 8px', fontSize: 34, fontWeight: 700, color: dark ? '#fff' : MK.textPrimary, letterSpacing: 0.37 }}>
          {title}
        </div>
      )}
    </div>
  );
}

function Card({ children, style = {} }) {
  return (
    <div style={{ background: MK.surface, borderRadius: 12, overflow: 'hidden', ...style }}>{children}</div>
  );
}

function PrimaryButton({ children, full = true, style = {} }) {
  return (
    <div style={{
      background: MK.primary, color: '#fff', fontWeight: 600, fontSize: 17,
      height: 50, borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center',
      width: full ? '100%' : 'auto', boxSizing: 'border-box', padding: '0 24px',
      boxShadow: '0 2px 6px rgba(74,144,217,0.25)', ...style,
    }}>{children}</div>
  );
}

function SecondaryButton({ children, style = {} }) {
  return (
    <div style={{
      background: MK.surfaceSecondary, color: MK.textPrimary, fontWeight: 600, fontSize: 17,
      height: 50, borderRadius: 14, display: 'flex', alignItems: 'center', justifyContent: 'center',
      ...style,
    }}>{children}</div>
  );
}

function SectionHeader({ children }) {
  return (
    <div style={{ padding: '20px 32px 6px', fontSize: 13, color: MK.textSecondary, textTransform: 'uppercase', letterSpacing: 0.5, fontWeight: 500 }}>
      {children}
    </div>
  );
}

function FormRow({ label, value, placeholder, last, type = 'text' }) {
  const displayValue = value !== undefined ? value : (
    <span style={{ color: MK.textTertiary }}>{placeholder}</span>
  );
  return (
    <div style={{ display: 'flex', alignItems: 'center', minHeight: 44, padding: '11px 16px', position: 'relative', fontSize: 17, color: MK.textPrimary }}>
      {label && <div style={{ width: 110, color: MK.textPrimary }}>{label}</div>}
      <div style={{ flex: 1, color: value === undefined ? MK.textTertiary : MK.textPrimary }}>
        {type === 'password' && value ? '••••••••' : displayValue}
      </div>
      {!last && <div style={{ position: 'absolute', bottom: 0, left: label ? 126 : 16, right: 0, height: 0.5, background: MK.separator }}/>}
    </div>
  );
}

// Avatar circle with initial
function Avatar({ letter, size = 48 }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%', background: MK.primaryLight,
      color: MK.primary, fontSize: size * 0.46, fontWeight: 700,
      display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
    }}>{letter}</div>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 1. WELCOME
// ──────────────────────────────────────────────────────────────────────

function WelcomeScreen() {
  return (
    <Phone bg="#FFFFFF">
      <div style={{ padding: '64px 24px 40px', height: '100%', display: 'flex', flexDirection: 'column', boxSizing: 'border-box' }}>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 24 }}>
          <div style={{
            width: 132, height: 132, borderRadius: 32, background: MK.primaryLight,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            {Icons.family(80, MK.primary)}
          </div>
          <div style={{ textAlign: 'center', display: 'flex', flexDirection: 'column', gap: 8 }}>
            <div style={{ fontSize: 34, fontWeight: 700, color: MK.textPrimary, letterSpacing: 0.37 }}>MyKids</div>
            <div style={{ fontSize: 17, color: MK.textSecondary, maxWidth: 280, lineHeight: 1.35 }}>
              Track your children's health events
            </div>
          </div>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <PrimaryButton>Sign In</PrimaryButton>
          <SecondaryButton>Create Account</SecondaryButton>
          <div style={{ textAlign: 'center', padding: '12px 0 4px', color: MK.primary, fontSize: 17, fontWeight: 500 }}>
            Continue as Guest
          </div>
          <div style={{ textAlign: 'center', fontSize: 13, color: MK.textSecondary, lineHeight: 1.45, padding: '0 28px' }}>
            Guest mode saves data on this device only. Sign in to sync and share.
          </div>
        </div>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 2. LOGIN (modal sheet style)
// ──────────────────────────────────────────────────────────────────────

function LoginScreen() {
  return (
    <Phone>
      {/* sheet handle */}
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Sign In"
        leading={<span>Cancel</span>}
        trailing={null} />
      <div style={{ padding: '8px 0' }}>
        <SectionHeader>&nbsp;</SectionHeader>
        <div style={{ margin: '0 16px' }}>
          <Card>
            <FormRow placeholder="Email" />
            <FormRow placeholder="Password" type="password" last />
          </Card>
        </div>
        <div style={{ padding: '28px 16px 0' }}>
          <PrimaryButton>Sign In</PrimaryButton>
        </div>
        <div style={{ flex: 1 }}/>
        <div style={{ textAlign: 'center', padding: '40px 16px', fontSize: 15 }}>
          <span style={{ color: MK.textSecondary }}>Don't have an account? </span>
          <span style={{ color: MK.primary, fontWeight: 500 }}>Create one</span>
        </div>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 3. REGISTER
// ──────────────────────────────────────────────────────────────────────

function RegisterScreen() {
  return (
    <Phone>
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Create Account" leading={<span>Cancel</span>} />
      <SectionHeader>Your Name</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <FormRow placeholder="Full name (optional)" last />
        </Card>
      </div>
      <SectionHeader>Account</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <FormRow placeholder="Email" />
          <FormRow placeholder="Password (min 6)" type="password" />
          <FormRow placeholder="Confirm Password" type="password" last />
        </Card>
      </div>
      <div style={{ padding: '28px 16px 0' }}>
        <PrimaryButton>Create Account</PrimaryButton>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 4. CHILDREN LIST (filled)
// ──────────────────────────────────────────────────────────────────────

function ChildRow({ letter, name, birth, last }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', padding: '12px 16px', minHeight: 64, gap: 14, position: 'relative' }}>
      <Avatar letter={letter} />
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 3 }}>
        <div style={{ fontSize: 17, fontWeight: 600, color: MK.textPrimary }}>{name}</div>
        {birth && <div style={{ fontSize: 13, color: MK.textSecondary }}>Born {birth}</div>}
      </div>
      {Icons.chevronRight(11, MK.textTertiary)}
      {!last && <div style={{ position: 'absolute', bottom: 0, left: 76, right: 0, height: 0.5, background: MK.separator }}/>}
    </div>
  );
}

function ChildrenListFilled() {
  return (
    <Phone>
      <NavBar
        title="My Kids"
        leading={<><div style={{ width: 22, height: 22 }}>{Icons.personPlus(22)}</div></>}
        trailing={Icons.plus(26)}
      />
      <div style={{ padding: '8px 0' }}>
        <div style={{ margin: '0 16px' }}>
          <Card>
            <ChildRow letter="A" name="Adam" birth="March 5, 2021" />
            <ChildRow letter="L" name="Lena" birth="August 12, 2023" />
            <ChildRow letter="N" name="Noor" birth="January 22, 2019" last />
          </Card>
        </div>
      </div>
      <TabBar active="children" />
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 5. CHILDREN LIST (empty)
// ──────────────────────────────────────────────────────────────────────

function ChildrenListEmpty() {
  return (
    <Phone>
      <NavBar title="My Kids" trailing={Icons.plus(26)} />
      <div style={{
        position: 'absolute', inset: 0, paddingTop: 110, paddingBottom: 130,
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 14,
      }}>
        <div style={{ opacity: 0.4 }}>{Icons.family(72, MK.textSecondary)}</div>
        <div style={{ fontSize: 20, fontWeight: 600, color: MK.textPrimary, marginTop: 6 }}>No Children Yet</div>
        <div style={{ fontSize: 15, color: MK.textSecondary, textAlign: 'center', maxWidth: 240, lineHeight: 1.4 }}>
          Tap + to add your first child
        </div>
        <div style={{ marginTop: 24, padding: '12px 24px', borderRadius: 14, border: `1.5px solid ${MK.primary}`, color: MK.primary, fontWeight: 600, fontSize: 17 }}>
          Accept Invite
        </div>
      </div>
      <TabBar active="children" />
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 6. ADD / EDIT CHILD sheet
// ──────────────────────────────────────────────────────────────────────

function AddChildScreen() {
  return (
    <Phone>
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Add Child"
        leading={<span>Cancel</span>}
        trailing={<span style={{ fontWeight: 600 }}>Save</span>} />
      <SectionHeader>Child's Name</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card><FormRow placeholder="Name" last /></Card>
      </div>
      <div style={{ height: 20 }}/>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <div style={{ display: 'flex', alignItems: 'center', padding: '11px 16px', minHeight: 44, position: 'relative' }}>
            <div style={{ flex: 1, fontSize: 17 }}>Add Birth Date</div>
            <div style={{ width: 51, height: 31, borderRadius: 16, background: MK.success, position: 'relative' }}>
              <div style={{ position: 'absolute', top: 2, right: 2, width: 27, height: 27, borderRadius: '50%', background: '#fff', boxShadow: '0 2px 4px rgba(0,0,0,0.15)' }}/>
            </div>
            <div style={{ position: 'absolute', bottom: 0, left: 16, right: 0, height: 0.5, background: MK.separator }}/>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', padding: '11px 16px', minHeight: 44 }}>
            <div style={{ flex: 1, fontSize: 17 }}>Birth Date</div>
            <div style={{ background: MK.surfaceSecondary, borderRadius: 7, padding: '4px 10px', fontSize: 17, color: MK.textPrimary }}>
              Mar 5, 2021
            </div>
          </div>
        </Card>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 7. EVENT LIST (filled)
// ──────────────────────────────────────────────────────────────────────

function FilterChip({ label, active, color = MK.primary }) {
  return (
    <div style={{
      padding: '7px 14px', borderRadius: 999, fontSize: 14, fontWeight: 500,
      background: active ? color : MK.surfaceSecondary,
      color: active ? '#fff' : MK.textPrimary, whiteSpace: 'nowrap',
    }}>{label}</div>
  );
}

function EventRow({ icon, title, time, notes, last, sub }) {
  return (
    <div style={{ padding: '12px 16px', display: 'flex', alignItems: 'flex-start', gap: 14, position: 'relative' }}>
      <div style={{
        width: 36, height: 36, borderRadius: 9, display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: 'rgba(0,0,0,0.04)', flexShrink: 0, marginTop: 1,
      }}>{icon}</div>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 2 }}>
        <div style={{ fontSize: 16, fontWeight: 600, color: MK.textPrimary }}>{title}</div>
        <div style={{ fontSize: 13, color: MK.textSecondary }}>{time}{sub ? ` · ${sub}` : ''}</div>
        {notes && (
          <div style={{ fontSize: 14, color: MK.textPrimary, marginTop: 8, padding: '8px 10px', background: MK.surfaceSecondary, borderRadius: 8, lineHeight: 1.35 }}>
            {notes}
          </div>
        )}
      </div>
      <div style={{ padding: '4px 0' }}>{Icons.ellipsis(18)}</div>
      {!last && <div style={{ position: 'absolute', bottom: 0, left: 66, right: 0, height: 0.5, background: MK.separator }}/>}
    </div>
  );
}

function DayHeader({ label, count, expanded = true }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', padding: '20px 20px 8px', gap: 8 }}>
      <div style={{ fontSize: 13, fontWeight: 600, color: MK.textSecondary, textTransform: 'uppercase', letterSpacing: 0.5 }}>{label}</div>
      <div style={{ fontSize: 13, color: MK.textTertiary }}>{count}</div>
      <div style={{ flex: 1 }}/>
      <div style={{ transform: expanded ? 'rotate(0deg)' : 'rotate(-90deg)', transition: 'transform .2s' }}>
        {Icons.chevronDown(14)}
      </div>
    </div>
  );
}

function EventListFilled() {
  return (
    <Phone>
      <NavBar
        title="Adam"
        leading={<><span style={{ marginLeft: -4, marginRight: 2 }}>{Icons.chevronLeft(18)}</span><span>My Kids</span></>}
        trailing={<><div style={{ width: 22 }}>{Icons.share(22)}</div><div style={{ width: 22 }}>{Icons.plus(24)}</div></>}
      />
      {/* filter bar */}
      <div style={{ display: 'flex', gap: 8, padding: '4px 16px 12px', overflow: 'hidden' }}>
        <FilterChip label="Medicine" active color={MK.medicine}/>
        <FilterChip label="Temperature"/>
        <FilterChip label="Custom Event"/>
      </div>

      <DayHeader label="Today" count="2" />
      <div style={{ margin: '0 16px' }}>
        <Card>
          <EventRow
            icon={Icons.pill(22)}
            title="Panadol — 250 mg"
            time="2:30 PM"
          />
          <EventRow
            icon={Icons.pill(22)}
            title="Vitamin D — 1 tablet"
            time="9:15 AM"
            notes="Took with breakfast. No reaction."
            last
          />
        </Card>
      </div>

      <DayHeader label="Yesterday" count="3" expanded={false} />

      <DayHeader label="May 20, 2026" count="1" expanded={false} />

      <TabBar active="children"/>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 8. EVENT LIST (empty)
// ──────────────────────────────────────────────────────────────────────

function EventListEmpty() {
  return (
    <Phone>
      <NavBar
        title="Adam"
        leading={<><span style={{ marginLeft: -4, marginRight: 2 }}>{Icons.chevronLeft(18)}</span><span>My Kids</span></>}
        trailing={<><div style={{ width: 22 }}>{Icons.share(22)}</div><div style={{ width: 22 }}>{Icons.plus(24)}</div></>}
      />
      <div style={{ display: 'flex', gap: 8, padding: '4px 16px 12px', overflow: 'hidden' }}>
        <FilterChip label="Medicine" active color={MK.medicine}/>
        <FilterChip label="Temperature"/>
        <FilterChip label="Custom Event"/>
      </div>
      <div style={{
        position: 'absolute', inset: 0, paddingTop: 220, paddingBottom: 130,
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'flex-start', gap: 12,
      }}>
        <div style={{ opacity: 0.5 }}>{Icons.tray(56, MK.textTertiary)}</div>
        <div style={{ fontSize: 20, fontWeight: 600, color: MK.textPrimary, marginTop: 4 }}>No Events</div>
        <div style={{ fontSize: 15, color: MK.textSecondary, textAlign: 'center', maxWidth: 240, lineHeight: 1.4 }}>
          No Medicine events yet
        </div>
      </div>
      <TabBar active="children"/>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 9. ADD EVENT sheet (Medicine variant)
// ──────────────────────────────────────────────────────────────────────

function SegmentedControl({ options, active }) {
  return (
    <div style={{ display: 'flex', background: 'rgba(118,118,128,0.12)', borderRadius: 9, padding: 2, position: 'relative' }}>
      {options.map((o, i) => (
        <div key={i} style={{
          flex: 1, textAlign: 'center', fontSize: 13, fontWeight: i === active ? 600 : 500,
          padding: '6px 8px', borderRadius: 7,
          background: i === active ? '#fff' : 'transparent',
          boxShadow: i === active ? '0 3px 8px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.04)' : 'none',
          color: MK.textPrimary,
        }}>{o}</div>
      ))}
    </div>
  );
}

function AddEventScreen() {
  return (
    <Phone>
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Log Event"
        leading={<span>Cancel</span>}
        trailing={<span style={{ fontWeight: 600 }}>Save</span>} />

      <SectionHeader>Event Type</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <SegmentedControl options={['Medicine','Temperature','Custom']} active={0}/>
      </div>

      <SectionHeader>Time</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <SegmentedControl options={['Now','Custom']} active={0}/>
      </div>

      <SectionHeader>Medicine</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <FormRow placeholder="Medicine name" value="Panadol" />
          <FormRow placeholder="Dose" value="250" />
          <div style={{ display: 'flex', alignItems: 'center', padding: '11px 16px', minHeight: 44 }}>
            <div style={{ flex: 1, fontSize: 17 }}>Unit</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 4, color: MK.textSecondary }}>
              <span style={{ fontSize: 17 }}>mg</span>
              {Icons.chevronRight(11)}
            </div>
          </div>
        </Card>
      </div>

      <SectionHeader>Notes (Optional)</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card style={{ minHeight: 100, padding: '12px 16px' }}>
          <span style={{ fontSize: 17, color: MK.textTertiary }}>Notes...</span>
        </Card>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 10. SHARE CHILD (before & after)
// ──────────────────────────────────────────────────────────────────────

function ShareChildBefore() {
  return (
    <Phone>
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Share Adam"
        leading={null}
        trailing={<span style={{ fontWeight: 600 }}>Done</span>} />
      <div style={{ padding: '16px 24px 0', fontSize: 15, color: MK.textSecondary, lineHeight: 1.45 }}>
        Share Adam's profile with another parent. They'll be able to view and add health events.
      </div>
      <SectionHeader>Invite Code</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <PrimaryButton>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            {Icons.linkBadgePlus(22, '#fff')}
            <span>Generate Invite Code</span>
          </div>
        </PrimaryButton>
      </div>
      <div style={{ padding: '24px 24px 0' }}>
        <div style={{ height: 0.5, background: MK.separator }}/>
        <div style={{ marginTop: 16, fontSize: 13, color: MK.textSecondary, textAlign: 'center', lineHeight: 1.45 }}>
          Each code is single-use and expires in 7 days.
        </div>
      </div>
    </Phone>
  );
}

function ShareChildAfter() {
  return (
    <Phone>
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Share Adam"
        trailing={<span style={{ fontWeight: 600 }}>Done</span>} />

      <SectionHeader>Invite Code</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <div style={{
          background: MK.surfaceSecondary, borderRadius: 16, padding: '36px 16px',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <div style={{ fontFamily: MK.mono, fontSize: 28, fontWeight: 700, letterSpacing: 4, color: MK.textPrimary }}>
            AB3D 5FGH
          </div>
        </div>
        <div style={{ padding: '10px 4px 0', fontSize: 13, color: MK.textSecondary }}>
          Expires May 30, 2026
        </div>
      </div>

      <div style={{ padding: '24px 16px 0', display: 'flex', flexDirection: 'column', gap: 12 }}>
        <div style={{
          height: 50, borderRadius: 14, border: `1.5px solid ${MK.primary}`, color: MK.primary,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, fontWeight: 600, fontSize: 17,
        }}>
          {Icons.copy(18, MK.primary)}
          <span>Copy Code</span>
        </div>
        <PrimaryButton>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            {Icons.share(20, '#fff')}
            <span>Share via…</span>
          </div>
        </PrimaryButton>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 11. ACCEPT INVITE
// ──────────────────────────────────────────────────────────────────────

function AcceptInviteScreen() {
  return (
    <Phone>
      <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 6, paddingBottom: 4 }}>
        <div style={{ width: 36, height: 5, borderRadius: 3, background: MK.textTertiary, opacity: 0.6 }}/>
      </div>
      <NavBar largeTitle={false} title="Accept Invite" leading={<span>Cancel</span>} />
      <div style={{ padding: '16px 24px 0', fontSize: 15, color: MK.textSecondary, lineHeight: 1.45 }}>
        Enter the invite code shared by another parent.
      </div>
      <SectionHeader>Invite Code</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <div style={{ padding: '16px', fontFamily: MK.mono, fontSize: 22, fontWeight: 600, letterSpacing: 2, color: MK.textPrimary }}>
            AB3D5FGH
          </div>
        </Card>
      </div>
      <div style={{ padding: '28px 16px 0' }}>
        <PrimaryButton>Join</PrimaryButton>
      </div>
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 12. SETTINGS — logged in
// ──────────────────────────────────────────────────────────────────────

function SettingsLoggedIn() {
  return (
    <Phone>
      <NavBar title="Settings" />
      <SectionHeader>Account</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <FormRow label="Name" value="Ahmed" />
          <FormRow label="Email" value="ahmed@example.com" last />
        </Card>
      </div>
      <div style={{ height: 16 }}/>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <div style={{ display: 'flex', alignItems: 'center', padding: '14px 16px', gap: 10 }}>
            {Icons.signOut(20, MK.destructive)}
            <div style={{ fontSize: 17, color: MK.destructive, fontWeight: 500 }}>Sign Out</div>
          </div>
        </Card>
      </div>
      <SectionHeader>About</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <FormRow label="Version" value="1.0" last />
        </Card>
      </div>
      <TabBar active="settings" />
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// 13. SETTINGS — guest mode
// ──────────────────────────────────────────────────────────────────────

function SettingsGuest() {
  return (
    <Phone>
      <NavBar title="Settings" />
      <SectionHeader>Mode</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <div style={{ padding: '16px', display: 'flex', alignItems: 'flex-start', gap: 12 }}>
            <div style={{ width: 36, height: 36, borderRadius: 9, background: MK.primaryLight, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              {Icons.person(20, MK.primary)}
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 17, fontWeight: 600, color: MK.textPrimary, marginBottom: 2 }}>Guest Mode</div>
              <div style={{ fontSize: 14, color: MK.textSecondary, lineHeight: 1.4 }}>Your data is on this device only. Sign in to sync across devices and share with co-parents.</div>
            </div>
          </div>
        </Card>
      </div>
      <div style={{ height: 16 }}/>
      <div style={{ margin: '0 16px' }}>
        <Card>
          <div style={{ display: 'flex', alignItems: 'center', padding: '13px 16px', position: 'relative' }}>
            <div style={{ flex: 1, fontSize: 17, color: MK.primary, fontWeight: 500 }}>Sign In</div>
            {Icons.chevronRight(11)}
            <div style={{ position: 'absolute', bottom: 0, left: 16, right: 0, height: 0.5, background: MK.separator }}/>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', padding: '13px 16px' }}>
            <div style={{ flex: 1, fontSize: 17, color: MK.primary, fontWeight: 500 }}>Create Account</div>
            {Icons.chevronRight(11)}
          </div>
        </Card>
      </div>
      <SectionHeader>About</SectionHeader>
      <div style={{ margin: '0 16px' }}>
        <Card><FormRow label="Version" value="1.0" last /></Card>
      </div>
      <TabBar active="settings" />
    </Phone>
  );
}

// ──────────────────────────────────────────────────────────────────────
// APP ICON (rendered as <AppIconPreview /> at any size)
// ──────────────────────────────────────────────────────────────────────

function AppIconPreview({ size = 200 }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: size * 0.225,
      background: 'linear-gradient(160deg, #6FB1ED 0%, #4A90D9 55%, #2F73C0 100%)',
      position: 'relative', overflow: 'hidden',
      boxShadow: `0 ${size*0.04}px ${size*0.1}px rgba(74,144,217,0.35), inset 0 ${size*0.005}px 0 rgba(255,255,255,0.3)`,
    }}>
      {/* soft highlight */}
      <div style={{
        position: 'absolute', inset: 0, borderRadius: 'inherit',
        background: 'radial-gradient(circle at 30% 20%, rgba(255,255,255,0.35) 0%, rgba(255,255,255,0) 50%)',
      }}/>
      {/* family glyph */}
      <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <svg width={size * 0.62} height={size * 0.52} viewBox="0 0 100 85">
          <circle cx="28" cy="18" r="11" fill="#fff"/>
          <path d="M14 50c0-7.7 6.3-14 14-14s14 6.3 14 14v20a3 3 0 01-3 3H17a3 3 0 01-3-3V50z" fill="#fff"/>
          <circle cx="72" cy="30" r="8.5" fill="#fff" fillOpacity="0.9"/>
          <path d="M60 58c0-6.6 5.4-12 12-12s12 5.4 12 12v12a3 3 0 01-3 3H63a3 3 0 01-3-3V58z" fill="#fff" fillOpacity="0.9"/>
          <path d="M43 62 L58 62" stroke="#fff" strokeWidth="4" strokeLinecap="round" opacity="0.85"/>
        </svg>
      </div>
    </div>
  );
}

Object.assign(window, {
  WelcomeScreen, LoginScreen, RegisterScreen,
  ChildrenListFilled, ChildrenListEmpty, AddChildScreen,
  EventListFilled, EventListEmpty, AddEventScreen,
  ShareChildBefore, ShareChildAfter, AcceptInviteScreen,
  SettingsLoggedIn, SettingsGuest, AppIconPreview, MK, Icons,
});
