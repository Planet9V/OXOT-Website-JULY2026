"use client";
import { Reveal, Stagger } from "@/components/motion/fx";

export interface ApproachStep { k: string; title: string; body: string }
export interface ApproachContent {
  eyebrow: string;
  heading: string;
  intro: string;
  steps: ApproachStep[];
}

export function HomeApproach({ content }: { content: ApproachContent }) {
  return (
    <section className="ed-appr">
      <Reveal>
        <div className="ed-appr-head">
          <p className="ed-eyebrow">{content.eyebrow}</p>
          <h2 className="ed-h2">{content.heading}</h2>
          <p className="ed-appr-intro">{content.intro}</p>
        </div>
      </Reveal>
      <Stagger>
        <div className="ed-appr-grid">
          {content.steps.map((s) => (
            <Stagger.Item key={s.k}>
              <div className="ed-appr-step">
                <span className="ed-appr-k">{s.k}</span>
                <h3>{s.title}</h3>
                <p>{s.body}</p>
              </div>
            </Stagger.Item>
          ))}
        </div>
      </Stagger>
    </section>
  );
}
