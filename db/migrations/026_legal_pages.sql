-- 026_legal_pages.sql
-- Seed CMS-managed legal pages (privacy, terms, cookies) in EN + NL so they resolve
-- via the existing [slug] route and are editable in the admin. Idempotent upsert on
-- (slug, locale). Bodies are dollar-quoted ($$...$$) to avoid apostrophe escaping.
-- Templates only — general boilerplate, to be reviewed by legal counsel before relying on it.

-- ============================ PRIVACY — EN ============================
INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('privacy', 'en', 'Privacy Policy', $$_This is a general template — have it reviewed by legal counsel before relying on it._

OXOT ("we", "us", "our") respects your privacy and is committed to protecting your personal data in line with the EU General Data Protection Regulation (GDPR) and applicable Dutch law. This policy explains what personal data we process when you use this website, why we process it, and the rights you have.

## Who is responsible for your data

The data controller is OXOT. If you have any question about this policy or how we handle your personal data, contact us at **hello@oxot.eu**.

## What data we collect

We keep data collection to what we genuinely need:

- **Contact form.** When you contact us, we process the name, email address, organisation and message you provide, so we can respond and follow up.
- **Newsletter.** If you subscribe, we process your email address and language preference to send you the updates you asked for. You can unsubscribe at any time.
- **Analytics and cookies.** With your consent, we process limited, first-party usage data (pages viewed, clicks, approximate session information) to understand how the site is used and improve it. No analytics data is collected before you consent. See our [Cookie Policy](/en/cookies).
- **On-site AI assistant.** If you use the AI assistant, the questions you type and the assistant's answers may be processed and briefly logged so the assistant can respond in context and so we can improve its quality. Please do not enter sensitive personal data into the assistant.
- **Server logs.** Like most websites, our infrastructure records technical data (such as a truncated or hashed IP address and browser type) needed for security and reliability.

## Why we process it, and our legal basis

- To **answer your enquiry** and manage our relationship with you — legal basis: our legitimate interest, or steps taken at your request prior to a contract.
- To **send newsletters** you subscribed to — legal basis: your consent.
- To run **analytics** and improve the site — legal basis: your consent.
- To keep the site **secure and available** — legal basis: our legitimate interest.

## How long we keep it

We retain personal data only as long as necessary for the purpose it was collected for, or as required by law. Enquiries are kept for the duration of our contact and a reasonable follow-up period; newsletter data is kept until you unsubscribe; consent-based analytics is retained for a limited period and then aggregated or deleted.

## Who we share it with

We do not sell your personal data. We share it only with service providers who process data on our behalf (for example hosting and infrastructure) under appropriate agreements, and where required by law. Where data is processed outside the EEA, we rely on appropriate safeguards such as Standard Contractual Clauses.

## Your rights under the GDPR

You have the right to access, rectify, erase, restrict or object to the processing of your personal data, the right to data portability, and the right to withdraw consent at any time without affecting prior processing. To exercise any of these rights, contact **hello@oxot.eu**. You also have the right to lodge a complaint with the Dutch Data Protection Authority (Autoriteit Persoonsgegevens).

## Changes to this policy

We may update this policy from time to time. The latest version is always published here.$$, true,
'Privacy Policy | OXOT', 'How OXOT collects, uses and protects your personal data under the GDPR — contact form, newsletter, analytics cookies and the on-site AI assistant.', 'How OXOT collects, uses and protects your personal data under the GDPR, and the rights you have.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

-- ============================ PRIVACY — NL ============================
INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('privacy', 'nl', 'Privacyverklaring', $$_Dit is een algemeen sjabloon — laat het door een juridisch adviseur beoordelen voordat u erop vertrouwt._

OXOT ("wij", "ons", "onze") respecteert uw privacy en zet zich in om uw persoonsgegevens te beschermen in overeenstemming met de Algemene Verordening Gegevensbescherming (AVG) en de toepasselijke Nederlandse wetgeving. In deze verklaring leest u welke persoonsgegevens wij verwerken wanneer u deze website gebruikt, waarom wij dat doen en welke rechten u heeft.

## Wie is verantwoordelijk voor uw gegevens

De verwerkingsverantwoordelijke is OXOT. Heeft u een vraag over deze verklaring of over hoe wij met uw persoonsgegevens omgaan, neem dan contact op via **hello@oxot.eu**.

## Welke gegevens wij verzamelen

Wij verzamelen niet meer dan wat wij echt nodig hebben:

- **Contactformulier.** Wanneer u contact met ons opneemt, verwerken wij de naam, het e-mailadres, de organisatie en het bericht die u opgeeft, zodat wij kunnen reageren en opvolgen.
- **Nieuwsbrief.** Als u zich aanmeldt, verwerken wij uw e-mailadres en taalvoorkeur om u de gevraagde updates te sturen. U kunt zich op elk moment afmelden.
- **Analytics en cookies.** Met uw toestemming verwerken wij beperkte, first-party gebruiksgegevens (bekeken pagina's, klikken, globale sessiegegevens) om te begrijpen hoe de site wordt gebruikt en deze te verbeteren. Er worden geen analytische gegevens verzameld voordat u toestemming geeft. Zie ons [Cookiebeleid](/nl/cookies).
- **AI-assistent op de site.** Als u de AI-assistent gebruikt, kunnen de vragen die u typt en de antwoorden van de assistent worden verwerkt en kort gelogd, zodat de assistent in context kan antwoorden en wij de kwaliteit kunnen verbeteren. Voer geen gevoelige persoonsgegevens in de assistent in.
- **Serverlogs.** Zoals de meeste websites registreert onze infrastructuur technische gegevens (zoals een ingekort of gehasht IP-adres en browsertype) die nodig zijn voor beveiliging en betrouwbaarheid.

## Waarom wij verwerken, en onze rechtsgrond

- Om **uw vraag te beantwoorden** en onze relatie met u te beheren — rechtsgrond: ons gerechtvaardigd belang, of stappen op uw verzoek voorafgaand aan een overeenkomst.
- Om **nieuwsbrieven** te sturen waarvoor u zich heeft aangemeld — rechtsgrond: uw toestemming.
- Om **analytics** uit te voeren en de site te verbeteren — rechtsgrond: uw toestemming.
- Om de site **veilig en beschikbaar** te houden — rechtsgrond: ons gerechtvaardigd belang.

## Hoe lang wij gegevens bewaren

Wij bewaren persoonsgegevens niet langer dan nodig is voor het doel waarvoor ze zijn verzameld, of dan wettelijk vereist. Aanvragen bewaren wij voor de duur van ons contact en een redelijke opvolgperiode; nieuwsbriefgegevens tot u zich afmeldt; op toestemming gebaseerde analytics bewaren wij een beperkte periode en aggregeren of verwijderen wij daarna.

## Met wie wij gegevens delen

Wij verkopen uw persoonsgegevens niet. Wij delen ze alleen met dienstverleners die namens ons gegevens verwerken (bijvoorbeeld hosting en infrastructuur) onder passende overeenkomsten, en waar de wet dit vereist. Worden gegevens buiten de EER verwerkt, dan steunen wij op passende waarborgen zoals modelcontractbepalingen (SCC's).

## Uw rechten onder de AVG

U heeft het recht op inzage, rectificatie, verwijdering, beperking van of bezwaar tegen de verwerking van uw persoonsgegevens, het recht op gegevensoverdraagbaarheid en het recht om uw toestemming op elk moment in te trekken zonder dat dit de eerdere verwerking aantast. Wilt u een van deze rechten uitoefenen, neem dan contact op via **hello@oxot.eu**. U heeft ook het recht een klacht in te dienen bij de Autoriteit Persoonsgegevens.

## Wijzigingen in deze verklaring

Wij kunnen deze verklaring van tijd tot tijd bijwerken. De meest recente versie wordt altijd hier gepubliceerd.$$, true,
'Privacyverklaring | OXOT', 'Hoe OXOT uw persoonsgegevens verzamelt, gebruikt en beschermt onder de AVG — contactformulier, nieuwsbrief, analytische cookies en de AI-assistent op de site.', 'Hoe OXOT uw persoonsgegevens verzamelt, gebruikt en beschermt onder de AVG, en welke rechten u heeft.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

-- ============================ TERMS — EN ============================
INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('terms', 'en', 'Terms of Use', $$_This is a general template — have it reviewed by legal counsel before relying on it._

These Terms of Use govern your access to and use of the OXOT website. By using the site, you agree to these terms. If you do not agree, please do not use the site.

## Use of the site

You may use this website for lawful, informational purposes. You agree not to misuse the site, disrupt its operation, attempt to gain unauthorised access, or use it in any way that infringes the rights of others or applicable law.

## Information, not advice

The content on this website — including material on the Cyber Resilience Act, the AI Act, the Machinery Regulation, NIS2, IEC 62443 and related topics — is provided for general information only. It does not constitute legal, regulatory or professional advice, and should not be relied upon as such. For advice on your specific situation, please contact us or your own advisers.

## Intellectual property

All content on this site — text, graphics, logos, and the OXOT name and branding — is owned by OXOT or its licensors and is protected by intellectual property law. You may view and share the content for personal, non-commercial use with attribution. You may not reproduce, republish or exploit it commercially without our prior written permission.

## No warranty

The site is provided "as is" and "as available", without warranties of any kind, whether express or implied, including but not limited to accuracy, completeness, fitness for a particular purpose, or uninterrupted availability. We may change, suspend or discontinue any part of the site at any time.

## Limitation of liability

To the fullest extent permitted by law, OXOT is not liable for any indirect, incidental or consequential loss arising from your use of, or inability to use, this website, or from reliance on its content. Nothing in these terms excludes liability that cannot be excluded under applicable law.

## Links to third-party sites

The site may link to third-party websites. We are not responsible for the content, policies or practices of those sites, and a link does not imply endorsement.

## Governing law

These terms are governed by the laws of the Netherlands and, where applicable, the European Union. Any dispute is subject to the exclusive jurisdiction of the competent Dutch courts.

## Contact

Questions about these terms can be sent to **hello@oxot.eu**.$$, true,
'Terms of Use | OXOT', 'The terms governing your use of the OXOT website — permitted use, intellectual property, disclaimer of warranties, limitation of liability and governing law.', 'The terms governing your use of the OXOT website, including intellectual property, disclaimers and governing law.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

-- ============================ TERMS — NL ============================
INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('terms', 'nl', 'Gebruiksvoorwaarden', $$_Dit is een algemeen sjabloon — laat het door een juridisch adviseur beoordelen voordat u erop vertrouwt._

Deze gebruiksvoorwaarden zijn van toepassing op uw toegang tot en gebruik van de OXOT-website. Door de site te gebruiken, gaat u akkoord met deze voorwaarden. Bent u het er niet mee eens, gebruik de site dan niet.

## Gebruik van de site

U mag deze website gebruiken voor rechtmatige, informatieve doeleinden. U gaat ermee akkoord de site niet te misbruiken, de werking ervan niet te verstoren, geen onbevoegde toegang te verkrijgen en de site niet te gebruiken op een manier die de rechten van anderen of de toepasselijke wetgeving schendt.

## Informatie, geen advies

De inhoud op deze website — waaronder materiaal over de Cyber Resilience Act, de AI-verordening, de Machineverordening, NIS2, IEC 62443 en aanverwante onderwerpen — wordt uitsluitend ter algemene informatie verstrekt. Het vormt geen juridisch, regelgevend of professioneel advies en u dient er niet als zodanig op te vertrouwen. Voor advies over uw specifieke situatie kunt u contact met ons of met uw eigen adviseurs opnemen.

## Intellectuele eigendom

Alle inhoud op deze site — tekst, afbeeldingen, logo's en de naam en huisstijl van OXOT — is eigendom van OXOT of haar licentiegevers en wordt beschermd door het recht op intellectuele eigendom. U mag de inhoud bekijken en delen voor persoonlijk, niet-commercieel gebruik met bronvermelding. U mag deze niet reproduceren, opnieuw publiceren of commercieel exploiteren zonder onze voorafgaande schriftelijke toestemming.

## Geen garantie

De site wordt aangeboden "zoals deze is" en "zoals beschikbaar", zonder enige garantie, expliciet of impliciet, met inbegrip van maar niet beperkt tot juistheid, volledigheid, geschiktheid voor een bepaald doel of ononderbroken beschikbaarheid. Wij kunnen elk onderdeel van de site op elk moment wijzigen, opschorten of beëindigen.

## Beperking van aansprakelijkheid

Voor zover wettelijk toegestaan is OXOT niet aansprakelijk voor indirecte, incidentele of gevolgschade die voortvloeit uit uw gebruik van, of het niet kunnen gebruiken van, deze website, of uit het vertrouwen op de inhoud ervan. Niets in deze voorwaarden sluit aansprakelijkheid uit die op grond van de toepasselijke wet niet kan worden uitgesloten.

## Links naar sites van derden

De site kan verwijzen naar websites van derden. Wij zijn niet verantwoordelijk voor de inhoud, het beleid of de praktijken van die sites, en een link houdt geen goedkeuring in.

## Toepasselijk recht

Op deze voorwaarden is het recht van Nederland en, waar van toepassing, van de Europese Unie van toepassing. Elk geschil valt onder de exclusieve bevoegdheid van de bevoegde Nederlandse rechter.

## Contact

Vragen over deze voorwaarden kunt u sturen naar **hello@oxot.eu**.$$, true,
'Gebruiksvoorwaarden | OXOT', 'De voorwaarden voor uw gebruik van de OXOT-website — toegestaan gebruik, intellectuele eigendom, uitsluiting van garanties, beperking van aansprakelijkheid en toepasselijk recht.', 'De voorwaarden voor uw gebruik van de OXOT-website, waaronder intellectuele eigendom, disclaimers en toepasselijk recht.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

-- ============================ COOKIES — EN ============================
INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cookies', 'en', 'Cookie Policy', $$_This is a general template — have it reviewed by legal counsel before relying on it._

This Cookie Policy explains how OXOT uses cookies and similar technologies on this website, and how you can control them. It should be read together with our [Privacy Policy](/en/privacy).

## What cookies are

Cookies are small text files placed on your device when you visit a website. They let the site remember your actions and preferences, and help us understand how the site is used.

## The cookies we use

- **Essential cookies.** These are necessary for the website to function — for example remembering your language and storing your cookie-consent choice. They are always active and do not require consent.
- **Analytics cookies.** With your consent, we use first-party analytics to understand how visitors use the site (pages viewed, clicks, approximate session data) so we can improve it. These are only set after you accept them, and they are never used to build advertising profiles.

We do not use third-party advertising or cross-site tracking cookies.

## The consent banner

On your first visit you will see a banner at the bottom of the screen. You can **Accept all** to allow analytics cookies, or **Decline non-essential** to keep only the cookies strictly needed for the site to work. Your choice is stored in a first-party cookie (`oxot_cookie_consent`) for about 180 days so we do not ask you again on every visit.

## Changing your choice

You can change your preference at any time by selecting **Cookie settings** in the footer, which reopens the banner. You can also delete cookies through your browser settings; most browsers let you block or remove cookies entirely, though this may affect how the site works.

## Changes to this policy

We may update this policy as our use of cookies changes. The latest version is always published here. Questions can be sent to **hello@oxot.eu**.$$, true,
'Cookie Policy | OXOT', 'How OXOT uses essential and analytics cookies, how the consent banner works, and how to change your cookie settings at any time.', 'How OXOT uses essential and analytics cookies, and how to change your cookie settings at any time.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();

-- ============================ COOKIES — NL ============================
INSERT INTO pages (slug, locale, title, body, published, meta_title, meta_description, excerpt, og_image, content_type, published_at, updated_at)
VALUES ('cookies', 'nl', 'Cookiebeleid', $$_Dit is een algemeen sjabloon — laat het door een juridisch adviseur beoordelen voordat u erop vertrouwt._

Dit cookiebeleid legt uit hoe OXOT cookies en vergelijkbare technologieën op deze website gebruikt en hoe u deze kunt beheren. Lees het samen met onze [Privacyverklaring](/nl/privacy).

## Wat cookies zijn

Cookies zijn kleine tekstbestanden die op uw apparaat worden geplaatst wanneer u een website bezoekt. Ze laten de site uw handelingen en voorkeuren onthouden en helpen ons te begrijpen hoe de site wordt gebruikt.

## De cookies die wij gebruiken

- **Essentiële cookies.** Deze zijn noodzakelijk om de website te laten werken — bijvoorbeeld om uw taal te onthouden en uw cookiekeuze op te slaan. Ze zijn altijd actief en vereisen geen toestemming.
- **Analytische cookies.** Met uw toestemming gebruiken wij first-party analytics om te begrijpen hoe bezoekers de site gebruiken (bekeken pagina's, klikken, globale sessiegegevens) zodat wij deze kunnen verbeteren. Ze worden pas geplaatst nadat u ze accepteert en worden nooit gebruikt om advertentieprofielen op te bouwen.

Wij gebruiken geen advertentie- of cross-site trackingcookies van derden.

## De toestemmingsbanner

Bij uw eerste bezoek ziet u onderaan het scherm een banner. U kunt **Alles accepteren** kiezen om analytische cookies toe te staan, of **Niet-essentiële weigeren** om alleen de cookies te behouden die strikt noodzakelijk zijn om de site te laten werken. Uw keuze wordt ongeveer 180 dagen bewaard in een first-party cookie (`oxot_cookie_consent`), zodat wij het niet bij elk bezoek opnieuw vragen.

## Uw keuze wijzigen

U kunt uw voorkeur op elk moment wijzigen via **Cookie-instellingen** in de voettekst, waarmee de banner opnieuw wordt geopend. U kunt cookies ook verwijderen via uw browserinstellingen; de meeste browsers laten u cookies volledig blokkeren of verwijderen, al kan dit invloed hebben op de werking van de site.

## Wijzigingen in dit beleid

Wij kunnen dit beleid bijwerken wanneer ons cookiegebruik verandert. De meest recente versie wordt altijd hier gepubliceerd. Vragen kunt u sturen naar **hello@oxot.eu**.$$, true,
'Cookiebeleid | OXOT', 'Hoe OXOT essentiële en analytische cookies gebruikt, hoe de toestemmingsbanner werkt en hoe u uw cookie-instellingen op elk moment kunt wijzigen.', 'Hoe OXOT essentiële en analytische cookies gebruikt, en hoe u uw cookie-instellingen op elk moment kunt wijzigen.', NULL, 'article', now(), now())
ON CONFLICT (slug, locale) DO UPDATE SET title=EXCLUDED.title, body=EXCLUDED.body, published=EXCLUDED.published, meta_title=EXCLUDED.meta_title, meta_description=EXCLUDED.meta_description, excerpt=EXCLUDED.excerpt, og_image=EXCLUDED.og_image, content_type=EXCLUDED.content_type, published_at=COALESCE(pages.published_at, EXCLUDED.published_at), updated_at=now();
