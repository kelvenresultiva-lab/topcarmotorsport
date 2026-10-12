// Supabase connection for the lead form and the admin page.
// Both values are PUBLIC by design (the "anon" key). Real protection comes from
// the row-level-security rules created by supabase-leads.sql.
window.LEADS_CONFIG = {
  url: 'https://mtkrgvrwckpxpbyrivbb.supabase.co',
  anonKey: 'sb_publishable_HiCX9ZOEff7PRlnSvm41PA_xh6Fu-lO'   // public (publishable) key
};
