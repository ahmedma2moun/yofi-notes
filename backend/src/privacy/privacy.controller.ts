import { Controller, Get, Res } from '@nestjs/common';
import { Response } from 'express';

@Controller('privacy')
export class PrivacyController {
  @Get()
  getPrivacyPolicy(@Res() res: Response) {
    res.setHeader('Content-Type', 'text/html');
    res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Privacy Policy – MyKids</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 720px;
      margin: 48px auto;
      padding: 0 24px 64px;
      color: #1c1c1e;
      line-height: 1.7;
    }
    h1 { font-size: 2rem; margin-bottom: 4px; }
    h2 { font-size: 1.1rem; margin-top: 32px; color: #3a3a3c; }
    p, li { font-size: 0.97rem; color: #3a3a3c; }
    ul { padding-left: 20px; }
    .updated { font-size: 0.85rem; color: #8e8e93; margin-bottom: 32px; }
    a { color: #007aff; }
  </style>
</head>
<body>
  <h1>Privacy Policy</h1>
  <p class="updated">Last updated: May 25, 2026</p>

  <p>
    MyKids ("we", "our", or "us") is committed to protecting your privacy.
    This policy explains what information we collect, how we use it, and your rights.
  </p>

  <h2>1. Information We Collect</h2>
  <ul>
    <li><strong>Account information:</strong> Name and email address when you register.</li>
    <li><strong>Child profiles:</strong> Names and details you enter for your children.</li>
    <li><strong>Health &amp; milestone events:</strong> Notes and events you log per child.</li>
    <li><strong>Device information:</strong> Basic device data required for app functionality.</li>
  </ul>

  <h2>2. How We Use Your Information</h2>
  <ul>
    <li>To provide and sync your child-tracking data across devices.</li>
    <li>To enable co-parent sharing when you invite another user via a sharing code.</li>
    <li>To authenticate your account securely using encrypted tokens.</li>
  </ul>

  <h2>3. Data Sharing</h2>
  <ul>
    <li>We do not sell your personal data to third parties.</li>
    <li>Your child's data is only shared with users you explicitly invite.</li>
    <li>We do not share your information with advertisers.</li>
  </ul>

  <h2>4. Guest Mode</h2>
  <p>
    Data created in guest mode is stored locally on your device only and is never
    transmitted to our servers.
  </p>

  <h2>5. Data Storage &amp; Security</h2>
  <ul>
    <li>Account data is stored on secured servers.</li>
    <li>Passwords are hashed and never stored in plain text.</li>
    <li>You can request deletion of your account and all associated data by contacting us.</li>
  </ul>

  <h2>6. Children's Privacy</h2>
  <p>
    MyKids is designed for parents to track their children's data.
    We do not knowingly collect personal information directly from children.
  </p>

  <h2>7. Changes to This Policy</h2>
  <p>
    We may update this policy from time to time. The updated date at the top of this
    page reflects the most recent revision.
  </p>

  <h2>8. Contact Us</h2>
  <p>
    For questions or data deletion requests, contact us at:
    <a href="mailto:ahmedfcisasu@gmail.com">ahmedfcisasu@gmail.com</a>
  </p>
</body>
</html>`);
  }
}
