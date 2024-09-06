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

    const response = await fetch("https://wellnessbruntal.cz/xmlCounter.php");
    const xml = await response.text();

    const countMatch = xml.match(/<Count>(\d+)<\/Count>/);
    const countValue = countMatch ? countMatch[1] : null;

    if (!countValue) {
      return new Response("Count value not found", { status: 500 });
    }

    const { error } = await supabase
      .from("visitors")
      .insert([{ visitors_count: countValue }]);

    if (error) {
      return new Response(error.message, { status: 500 });
    }

    return new Response(JSON.stringify({ countValue }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 });
  }
});
