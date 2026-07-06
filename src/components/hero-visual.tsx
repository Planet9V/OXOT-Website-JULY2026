/**
 * OXOT hero visual — the Cyber Digital Twin: fragmented OT inputs (left) resolve
 * into one structured node-graph (a "structured view") rising from a schematic
 * industrial base. Brand palette: navy #102030, steel-blue structure, one orange
 * #F07000 focal accent, off-white lines. Built vector, per the brand style guide.
 */
export function HeroVisual({ className = "" }: { className?: string }) {
  const edges: [number, number, number, number][] = [
    [300, 250, 360, 170], [300, 250, 250, 165], [360, 170, 430, 205],
    [360, 170, 400, 100], [250, 165, 200, 210], [250, 165, 300, 250],
    [430, 205, 470, 150], [400, 100, 360, 170], [300, 250, 230, 300],
    [430, 205, 300, 250], [200, 210, 160, 260]
  ];
  const nodes: [number, number, number][] = [
    [300, 250, 6], [360, 170, 5], [250, 165, 5], [430, 205, 5],
    [400, 100, 4], [470, 150, 4], [200, 210, 4], [230, 300, 4], [160, 260, 4]
  ];
  return (
    <svg viewBox="0 0 560 440" className={className} xmlns="http://www.w3.org/2000/svg" role="img"
         aria-label="OXOT Cyber Digital Twin: fragmented OT data resolving into one structured model">
      <defs>
        <linearGradient id="oxotPanel" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#132a40" />
          <stop offset="1" stopColor="#0d1a29" />
        </linearGradient>
        <radialGradient id="oxotGlow" cx="0.5" cy="0.5" r="0.5">
          <stop offset="0" stopColor="#f07000" stopOpacity="0.55" />
          <stop offset="1" stopColor="#f07000" stopOpacity="0" />
        </radialGradient>
      </defs>

      <rect x="1" y="1" width="558" height="438" rx="18" fill="url(#oxotPanel)" stroke="#2a3f57" />

      {/* zone grouping (dashed) */}
      <rect x="212" y="112" width="252" height="176" rx="12" fill="none" stroke="#4a6076" strokeDasharray="4 5" strokeOpacity="0.7" />
      <text x="220" y="106" fill="#7f93a8" fontSize="11" letterSpacing="2" fontFamily="sans-serif">ZONE · CONTROL</text>

      {/* fragmented inputs on the left converging in */}
      {[[54, 150], [46, 205], [58, 262], [50, 316]].map(([x, y], k) => (
        <g key={k}>
          <rect x={x} y={y} width="26" height="16" rx="3" fill="#22374d" stroke="#3c5670" />
          <line x1={x + 28} y1={y + 8} x2={200} y2={210} stroke="#4a6076" strokeOpacity="0.5" strokeDasharray="3 4" />
        </g>
      ))}
      <text x="46" y="132" fill="#7f93a8" fontSize="10.5" letterSpacing="1.5" fontFamily="sans-serif">FRAGMENTED FINDINGS</text>

      {/* industrial base (schematic) */}
      <g stroke="#43607b" strokeWidth="1.4" fill="#1a3047">
        <rect x="150" y="352" width="70" height="56" rx="3" />
        <rect x="236" y="336" width="44" height="72" rx="3" />
        <path d="M300 408 v-46 a18 18 0 0 1 36 0 v46 z" />
        <rect x="356" y="360" width="58" height="48" rx="3" />
        <rect x="430" y="344" width="30" height="64" rx="3" />
        <line x1="120" y1="408.5" x2="500" y2="408.5" stroke="#5a7690" strokeWidth="2" />
      </g>
      {/* conduits rising from base into the graph */}
      <g stroke="#3c5670" strokeWidth="1.3" strokeOpacity="0.85">
        <path d="M185 352 C185 320 230 300 230 300" fill="none" />
        <path d="M258 336 C258 300 300 250 300 250" fill="none" />
        <path d="M385 360 C385 300 430 205 430 205" fill="none" />
      </g>

      {/* graph edges */}
      <g stroke="#c6d2df" strokeOpacity="0.45" strokeWidth="1.2">
        {edges.map(([x1, y1, x2, y2], k) => <line key={k} x1={x1} y1={y1} x2={x2} y2={y2} />)}
      </g>

      {/* focal orange node (the decision / key risk) */}
      <circle cx="300" cy="250" r="34" fill="url(#oxotGlow)" />
      {/* graph nodes */}
      <g>
        {nodes.map(([cx, cy, r], k) => (
          <circle key={k} cx={cx} cy={cy} r={r} fill={k === 0 ? "#f07000" : "#9fb2c6"}
                  stroke={k === 0 ? "#ffd9b0" : "#5f7690"} strokeWidth={k === 0 ? 2 : 1} />
        ))}
      </g>
      <text x="300" y="238" textAnchor="middle" fill="#ffd9b0" fontSize="10.5" letterSpacing="1" fontFamily="sans-serif">RISK</text>

      <text x="330" y="60" fill="#e5e7eb" fontSize="15" fontFamily="Georgia, serif">One structured view</text>
      <text x="330" y="80" fill="#8aa0b6" fontSize="11.5" fontFamily="sans-serif">assets · risks · controls</text>
    </svg>
  );
}
