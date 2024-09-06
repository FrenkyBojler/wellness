import { createClient } from "jsr:@supabase/supabase-js@2";

Deno.serve(async (_req) => {
  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: _req.headers.get("Authorization")! },
        },
      }
    );

    const response = await fetch("https://wellnessbruntal.cz/");
    const html = await response.text();
    const match = html.match(/<span class="nmb">(\d+)<\/span>/);
    const visitors = match ? parseInt(match[1]) : 0;

    await supabase
      .from("visitors")
      .insert([{ count: visitors, created_at: new Date() }]);

    return new Response(JSON.stringify({ visitors }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 });
  }
});
