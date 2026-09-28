#!/bin/bash
# Erzeugt den Android-Projektordner aus index.html (wird vom GitHub-Workflow aufgerufen).
set -e
echo "Dateien im Repository:"; ls -la
mkdir -p app/src/main/assets
mkdir -p "$(dirname settings.gradle)"
cat > settings.gradle <<'PROJEKT_ENDE'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = 'FeuerWasser'
include ':app'
PROJEKT_ENDE
mkdir -p "$(dirname build.gradle)"
cat > build.gradle <<'PROJEKT_ENDE'
plugins {
    id 'com.android.application' version '8.5.2' apply false
}
PROJEKT_ENDE
mkdir -p "$(dirname gradle.properties)"
cat > gradle.properties <<'PROJEKT_ENDE'
org.gradle.jvmargs=-Xmx2g -Dfile.encoding=UTF-8
android.useAndroidX=false
android.nonTransitiveRClass=true
PROJEKT_ENDE
mkdir -p "$(dirname app/build.gradle)"
cat > app/build.gradle <<'PROJEKT_ENDE'
plugins {
    id 'com.android.application'
}

android {
    namespace 'de.feuerwasser.game'
    compileSdk 34

    defaultConfig {
        applicationId 'de.feuerwasser.game'
        minSdk 26
        targetSdk 34
        versionCode 1
        versionName '1.0'
    }

    buildTypes {
        release {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/AndroidManifest.xml)"
cat > app/src/main/AndroidManifest.xml <<'PROJEKT_ENDE'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />

    <application
        android:allowBackup="true"
        android:hardwareAccelerated="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme"
        android:usesCleartextTraffic="false">

        <activity
            android:name=".MainActivity"
            android:configChanges="orientation|screenSize|keyboardHidden|screenLayout|smallestScreenSize|uiMode|density|keyboard|navigation"
            android:exported="true"
            android:screenOrientation="sensorLandscape"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/res/values/strings.xml)"
cat > app/src/main/res/values/strings.xml <<'PROJEKT_ENDE'
<resources>
    <string name="app_name">Feuer &amp; Wasser</string>
</resources>
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/res/values/colors.xml)"
cat > app/src/main/res/values/colors.xml <<'PROJEKT_ENDE'
<resources>
    <color name="bg">#0F0E19</color>
    <color name="icon_bg">#1D2242</color>
</resources>
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/res/values/styles.xml)"
cat > app/src/main/res/values/styles.xml <<'PROJEKT_ENDE'
<resources>
    <style name="AppTheme" parent="android:Theme.Material.NoActionBar">
        <item name="android:windowFullscreen">true</item>
        <item name="android:windowBackground">@color/bg</item>
        <item name="android:statusBarColor">@color/bg</item>
        <item name="android:navigationBarColor">@color/bg</item>
    </style>
</resources>
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml)"
cat > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml <<'PROJEKT_ENDE'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/icon_bg" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/res/drawable/ic_launcher_foreground.xml)"
cat > app/src/main/res/drawable/ic_launcher_foreground.xml <<'PROJEKT_ENDE'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#FF6A2A"
        android:pathData="M40,28 C44,38 56,44 56,58 C56,69 49,76 40,76 C31,76 24,69 24,58 C24,50 30,44 32,37 C34,41 36,43 38,43 C38,38 38,32 40,28 Z" />
    <path
        android:fillColor="#FFD257"
        android:pathData="M40,52 C43,57 47,60 47,65 C47,70 44,73 40,73 C36,73 33,70 33,65 C33,61 37,58 40,52 Z" />
    <path
        android:fillColor="#3AA0FF"
        android:pathData="M70,36 C71,44 84,52 84,64 C84,72 78,78 70,78 C62,78 56,72 56,64 C56,52 69,44 70,36 Z" />
    <path
        android:fillColor="#CFEAFF"
        android:pathData="M64,62 C64,58 66,56 68,54 C66,58 66,62 67,66 C65,66 64,64 64,62 Z" />
</vector>
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/java/de/feuerwasser/game/MainActivity.java)"
cat > app/src/main/java/de/feuerwasser/game/MainActivity.java <<'PROJEKT_ENDE'
package de.feuerwasser.game;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.DhcpInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends Activity {

    private WebView web;
    private WifiManager.MulticastLock multicastLock;
    private long lastBack = 0;
    private LanNet lan = null;

    /** Meldungen der WLAN-Verbindung an das Spiel weiterreichen. */
    private final LanNet.Listener lanListener = new LanNet.Listener() {
        @Override public void onStatus(String s) { js("window.__fwNetStatus&&window.__fwNetStatus(" + JSONObject.quote(s) + ")"); }
        @Override public void onOpen() { js("window.__fwNetOpen&&window.__fwNetOpen()"); }
        @Override public void onMessage(String m) { js("window.__fwNetMsg&&window.__fwNetMsg(" + JSONObject.quote(m) + ")"); }
        @Override public void onClosed(String r) { js("window.__fwNetClosed&&window.__fwNetClosed(" + JSONObject.quote(r) + ")"); }
    };

    private void js(final String script) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (web != null) web.evaluateJavascript(script, null);
            }
        });
    }

    private static String intToIp(int a) {
        return (a & 0xff) + "." + ((a >> 8) & 0xff) + "." + ((a >> 16) & 0xff) + "." + ((a >> 24) & 0xff);
    }

    /** Wohin die Suchanfrage geschickt wird: Broadcast-Adressen und das Gateway (falls der Host der Hotspot ist). */
    @SuppressWarnings("deprecation")
    private List<String> lanTargets() {
        List<String> t = new ArrayList<String>(LanNet.broadcastTargets());
        try {
            WifiManager wm = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            DhcpInfo d = wm == null ? null : wm.getDhcpInfo();
            if (d != null) {
                if (d.ipAddress != 0 && d.netmask != 0) {
                    String bc = intToIp((d.ipAddress & d.netmask) | ~d.netmask);
                    if (!t.contains(bc)) t.add(bc);
                }
                if (d.gateway != 0) {
                    String gw = intToIp(d.gateway);
                    if (!t.contains(gw)) t.add(gw);
                }
            }
        } catch (Exception ignored) { }
        return t;
    }

    @SuppressLint({"SetJavaScriptEnabled", "AddJavascriptInterface"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Bildschirm bleibt an (wichtig fuer die Verbindung im Multiplayer)
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        if (Build.VERSION.SDK_INT >= 28) {
            WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.layoutInDisplayCutoutMode =
                    WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
            getWindow().setAttributes(lp);
        }

        web = new WebView(this);
        web.setBackgroundColor(Color.parseColor("#0F0E19"));
        web.setOverScrollMode(View.OVER_SCROLL_NEVER);
        web.setHapticFeedbackEnabled(false);
        setContentView(web);

        WebSettings s = web.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        s.setAllowFileAccess(true);
        s.setMediaPlaybackRequiresUserGesture(false);
        s.setSupportZoom(false);
        s.setBuiltInZoomControls(false);
        s.setCacheMode(WebSettings.LOAD_DEFAULT);

        web.addJavascriptInterface(new Bridge(), "AndroidBridge");
        web.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                return true; // nie aus dem Spiel wegnavigieren
            }
        });
        web.setWebChromeClient(new WebChromeClient());

        // Multicast erlauben, damit sich die Handys im WLAN per Namen finden (mDNS)
        try {
            WifiManager wm = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            if (wm != null) {
                multicastLock = wm.createMulticastLock("feuerwasser");
                multicastLock.setReferenceCounted(false);
                multicastLock.acquire();
            }
        } catch (Exception ignored) { }

        web.loadUrl("file:///android_asset/index.html");
    }

    /** Bruecke: Kopieren, Einfuegen und Teilen von Codes (fuer den Online-Modus). */
    private class Bridge {
        /** Spiel erstellen: gibt den 6-stelligen Code zurueck (leer bei Fehler). */
        @JavascriptInterface
        public String netHost() {
            try {
                if (lan != null) lan.close();
                lan = new LanNet(lanListener);
                return lan.host();
            } catch (Exception e) {
                if (lan != null) lan.close();
                return "";
            }
        }

        /** Spiel beitreten: sucht den Host mit diesem Code im WLAN. */
        @JavascriptInterface
        public void netJoin(String code) {
            if (lan != null) lan.close();
            lan = new LanNet(lanListener);
            lan.join(code, lanTargets());
        }

        @JavascriptInterface
        public void netSend(String msg) {
            LanNet l = lan;
            if (l != null) l.send(msg);
        }

        @JavascriptInterface
        public void netClose() {
            LanNet l = lan;
            if (l != null) l.close();
        }

        @JavascriptInterface
        public void copy(final String text) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                        cm.setPrimaryClip(ClipData.newPlainText("Code", text));
                    } catch (Exception ignored) { }
                }
            });
        }

        @JavascriptInterface
        public String paste() {
            try {
                ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                ClipData d = cm.getPrimaryClip();
                if (d != null && d.getItemCount() > 0) {
                    CharSequence cs = d.getItemAt(0).coerceToText(MainActivity.this);
                    return cs == null ? "" : cs.toString();
                }
            } catch (Exception ignored) { }
            return "";
        }

        @JavascriptInterface
        public void share(final String text) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        Intent i = new Intent(Intent.ACTION_SEND);
                        i.setType("text/plain");
                        i.putExtra(Intent.EXTRA_TEXT, text);
                        startActivity(Intent.createChooser(i, "Code senden"));
                    } catch (Exception ignored) { }
                }
            });
        }
    }

    @SuppressWarnings("deprecation")
    private void hideSystemUi() {
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) hideSystemUi();
    }

    @SuppressWarnings("deprecation")
    @Override
    public void onBackPressed() {
        long now = System.currentTimeMillis();
        if (now - lastBack < 1500) {
            super.onBackPressed(); // beendet die App
            return;
        }
        lastBack = now;
        // Zurueck = Menue im Spiel oeffnen/schliessen
        web.evaluateJavascript(
                "window.dispatchEvent(new KeyboardEvent('keydown',{code:'Escape'}))", null);
        Toast.makeText(this, "Zum Beenden zweimal Zurück", Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onResume() {
        super.onResume();
        web.onResume();
    }

    @Override
    protected void onPause() {
        web.onPause();
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        try {
            if (multicastLock != null && multicastLock.isHeld()) multicastLock.release();
        } catch (Exception ignored) { }
        if (lan != null) lan.close();
        if (web != null) web.destroy();
        super.onDestroy();
    }
}
PROJEKT_ENDE
mkdir -p "$(dirname app/src/main/java/de/feuerwasser/game/LanNet.java)"
cat > app/src/main/java/de/feuerwasser/game/LanNet.java <<'PROJEKT_ENDE'
package de.feuerwasser.game;

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.NetworkInterface;
import java.net.InterfaceAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.nio.charset.Charset;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * Verbindung zweier Geraete im selben WLAN, ohne Server.
 *
 * Host:  erzeugt einen 6-stelligen Code und wartet (UDP-Suchanfragen + TCP-Verbindung).
 * Gast:  gibt nur den Code ein. Er schickt eine Suchanfrage per Broadcast ins WLAN,
 *        der Host mit passendem Code antwortet, danach verbinden sich beide direkt per TCP.
 *
 * Nachrichten sind einzelne Textzeilen (JSON ohne Zeilenumbruch).
 */
public class LanNet {

    public interface Listener {
        /** searching, found, notfound, wrongcode, error */
        void onStatus(String status);
        void onOpen();
        void onMessage(String msg);
        void onClosed(String reason);
    }

    public static final int DISCOVERY_PORT = 47821;
    private static final String JOIN = "FWJ1|";
    private static final String HOST = "FWH1|";
    private static final Charset UTF8 = Charset.forName("UTF-8");

    private final Listener listener;
    private final int discoveryPort;
    private volatile int searchMillis = 12000;
    private volatile boolean closed = false;
    private volatile boolean open = false;

    private ServerSocket server;
    private DatagramSocket hostUdp;
    private DatagramSocket guestUdp;
    private Socket socket;
    private String code = "";
    private final LinkedBlockingQueue<String> out = new LinkedBlockingQueue<String>();

    public LanNet(Listener listener) {
        this(listener, DISCOVERY_PORT);
    }

    public LanNet(Listener listener, int discoveryPort) {
        this.listener = listener;
        this.discoveryPort = discoveryPort;
    }

    public void setSearchMillis(int ms) {
        this.searchMillis = ms;
    }

    public boolean isOpen() {
        return open && !closed;
    }

    // ------------------------------------------------------------------ Host

    /** Startet den Host und gibt den 6-stelligen Code zurueck. */
    public String host() throws IOException {
        code = String.format(Locale.ROOT, "%06d", 100000 + new SecureRandom().nextInt(900000));
        server = new ServerSocket(0);
        final int tcpPort = server.getLocalPort();

        hostUdp = new DatagramSocket(null);
        hostUdp.setReuseAddress(true);
        hostUdp.bind(new InetSocketAddress(discoveryPort));
        hostUdp.setBroadcast(true);

        start(new Runnable() {
            @Override
            public void run() {
                byte[] buf = new byte[128];
                while (!closed && !open) {
                    try {
                        DatagramPacket p = new DatagramPacket(buf, buf.length);
                        hostUdp.receive(p);
                        String s = new String(p.getData(), 0, p.getLength(), UTF8).trim();
                        if (s.equals(JOIN + code)) {
                            byte[] r = (HOST + tcpPort).getBytes(UTF8);
                            hostUdp.send(new DatagramPacket(r, r.length, p.getAddress(), p.getPort()));
                        }
                    } catch (IOException e) {
                        return;
                    }
                }
            }
        });

        start(new Runnable() {
            @Override
            public void run() {
                while (!closed && !open) {
                    Socket s = null;
                    try {
                        s = server.accept();
                        s.setTcpNoDelay(true);
                        s.setKeepAlive(true);
                        s.setSoTimeout(5000);
                        BufferedReader r = new BufferedReader(new InputStreamReader(s.getInputStream(), UTF8));
                        String first = r.readLine();
                        OutputStream o = s.getOutputStream();
                        if (first != null && first.equals("HELLO|" + code) && !open && !closed) {
                            o.write("OK\n".getBytes(UTF8));
                            o.flush();
                            s.setSoTimeout(0);
                            establish(s, r);
                            return;
                        } else {
                            try { o.write("NO\n".getBytes(UTF8)); o.flush(); } catch (IOException ignored) { }
                            quiet(s);
                        }
                    } catch (IOException e) {
                        quiet(s);
                        if (closed) return;
                    }
                }
            }
        });
        return code;
    }

    // ------------------------------------------------------------------ Gast

    /** Sucht den Host mit diesem Code. targets = Broadcast-/Gateway-Adressen. */
    public void join(final String joinCode, final List<String> targets) {
        code = joinCode;
        start(new Runnable() {
            @Override
            public void run() {
                try {
                    guestUdp = new DatagramSocket();
                    guestUdp.setBroadcast(true);
                    guestUdp.setSoTimeout(300);
                    listener.onStatus("searching");
                    byte[] msg = (JOIN + joinCode).getBytes(UTF8);
                    byte[] buf = new byte[128];
                    InetAddress hostAddr = null;
                    int hostPort = 0;
                    long end = System.currentTimeMillis() + searchMillis;
                    search:
                    while (!closed && System.currentTimeMillis() < end) {
                        for (String t : targets) {
                            try {
                                guestUdp.send(new DatagramPacket(msg, msg.length, InetAddress.getByName(t), discoveryPort));
                            } catch (Exception ignored) { }
                        }
                        long until = System.currentTimeMillis() + 700;
                        while (System.currentTimeMillis() < until) {
                            try {
                                DatagramPacket p = new DatagramPacket(buf, buf.length);
                                guestUdp.receive(p);
                                String s = new String(p.getData(), 0, p.getLength(), UTF8).trim();
                                if (s.startsWith(HOST)) {
                                    hostAddr = p.getAddress();
                                    hostPort = Integer.parseInt(s.substring(HOST.length()).trim());
                                    break search;
                                }
                            } catch (SocketTimeoutException ignored) {
                            } catch (NumberFormatException ignored) { }
                        }
                    }
                    quiet(guestUdp);
                    if (closed) return;
                    if (hostAddr == null) {
                        listener.onStatus("notfound");
                        return;
                    }
                    listener.onStatus("found");
                    Socket s = new Socket();
                    s.connect(new InetSocketAddress(hostAddr, hostPort), 4000);
                    s.setTcpNoDelay(true);
                    s.setKeepAlive(true);
                    s.setSoTimeout(5000);
                    OutputStream o = s.getOutputStream();
                    o.write(("HELLO|" + joinCode + "\n").getBytes(UTF8));
                    o.flush();
                    BufferedReader r = new BufferedReader(new InputStreamReader(s.getInputStream(), UTF8));
                    String ans = r.readLine();
                    if ("OK".equals(ans)) {
                        s.setSoTimeout(0);
                        establish(s, r);
                    } else {
                        quiet(s);
                        listener.onStatus("wrongcode");
                    }
                } catch (Exception e) {
                    if (!closed) listener.onStatus("error");
                }
            }
        });
    }

    // ------------------------------------------------------------ Verbindung

    private synchronized void establish(final Socket s, final BufferedReader r) {
        if (closed) {
            quiet(s);
            return;
        }
        socket = s;
        open = true;
        quiet(server);
        quiet(hostUdp);
        listener.onOpen();

        start(new Runnable() {
            @Override
            public void run() {
                try {
                    String line;
                    while (!closed && (line = r.readLine()) != null) {
                        listener.onMessage(line);
                    }
                } catch (IOException ignored) { }
                finish("closed");
            }
        });
        start(new Runnable() {
            @Override
            public void run() {
                try {
                    OutputStream o = s.getOutputStream();
                    while (!closed) {
                        String m = out.poll(500, TimeUnit.MILLISECONDS);
                        if (m == null) continue;
                        o.write((m + "\n").getBytes(UTF8));
                        int more = 0;
                        while (more++ < 20 && (m = out.poll()) != null) {
                            o.write((m + "\n").getBytes(UTF8));
                        }
                        o.flush();
                    }
                } catch (Exception e) {
                    finish("closed");
                }
            }
        });
    }

    /** Nachricht senden (haelt die Warteschlange kurz, alte Momentaufnahmen fallen weg). */
    public void send(String msg) {
        if (!open || closed || msg == null) return;
        if (out.size() > 25 && msg.startsWith("{\"t\":\"s\"")) return;
        out.offer(msg);
    }

    private synchronized void finish(String why) {
        if (closed) return;
        boolean wasOpen = open;
        closeAll();
        if (wasOpen) listener.onClosed(why);
    }

    /** Vom Benutzer gewollt beenden (keine Rueckmeldung). */
    public synchronized void close() {
        if (closed) return;
        closeAll();
    }

    private void closeAll() {
        closed = true;
        quiet(server);
        quiet(hostUdp);
        quiet(guestUdp);
        quiet(socket);
    }

    private static void quiet(Closeable c) {
        if (c == null) return;
        try { c.close(); } catch (IOException ignored) { }
    }

    private static void quiet(Socket s) {
        if (s == null) return;
        try { s.close(); } catch (IOException ignored) { }
    }

    private static void quiet(DatagramSocket s) {
        if (s == null) return;
        try { s.close(); } catch (Exception ignored) { }
    }

    private static void start(Runnable r) {
        Thread t = new Thread(r, "fw-net");
        t.setDaemon(true);
        t.start();
    }

    /** Alle Broadcast-Adressen der Netzwerk-Schnittstellen (auch Hotspot). */
    public static List<String> broadcastTargets() {
        List<String> res = new ArrayList<String>();
        res.add("255.255.255.255");
        try {
            Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
            while (en != null && en.hasMoreElements()) {
                NetworkInterface ni = en.nextElement();
                if (!ni.isUp() || ni.isLoopback()) continue;
                for (InterfaceAddress ia : ni.getInterfaceAddresses()) {
                    InetAddress b = ia.getBroadcast();
                    if (b != null && !res.contains(b.getHostAddress())) res.add(b.getHostAddress());
                }
            }
        } catch (Exception ignored) { }
        return res;
    }
}
PROJEKT_ENDE
HTML=$(find . -maxdepth 4 -iname '*.html' -not -path './app/*' -not -path './.git/*' | head -n 1)
if [ -z "$HTML" ]; then
  echo "::error::Keine HTML-Datei gefunden. Bitte die Datei index.html ins Repository hochladen."
  exit 1
fi
echo "Spiel-Datei: $HTML"
cp "$HTML" app/src/main/assets/index.html
echo "Projekt erzeugt:"; find app -type f | sort
