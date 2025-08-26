// All-in-one Cloudflare Worker for serving the ArgoSB Command Generator app.
// This single file contains the HTML, CSS, and TypeScript for the application.

const htmlContent = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ArgoSB Command Generator</title>
    <link rel="stylesheet" href="index.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header>
            <h1>ArgoSB Command Generator</h1>
            <p>Configure your proxy and tunnel setup with ease. Select your desired options, and the command will be generated for you automatically.</p>
        </header>

        <main>
            <section class="card">
                <h2 class="card-title">Quick Configuration</h2>
                <div class="quick-config-grid">
                    <button type="button" class="quick-config-btn" data-preset="vless-reality">VLESS + Reality</button>
                    <button type="button" class="quick-config-btn" data-preset="vmess-cdn">VMess + CDN</button>
                    <button type="button" class="quick-config-btn" data-preset="vmess-argo-temp">VMess + Argo (Temp)</button>
                    <button type="button" class="quick-config-btn" data-preset="vmess-argo-fixed">VMess + Argo (Fixed)</button>
                    <button type="button" class="quick-config-btn" data-preset="hysteria2">Hysteria2</button>
                    <button type="button" class="quick-config-btn" data-preset="reset">Reset Form</button>
                </div>
            </section>

            <form id="config-form">
                <section class="card">
                    <h2 class="card-title">Protocols</h2>
                    <div class="protocol-grid">
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="vlpt" data-env="vlpt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="vlpt">VLESS (Reality Vision)</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="xhpt" data-env="xhpt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="xhpt">VLESS (xhttp)</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="vmpt" data-env="vmpt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="vmpt">VMess (WebSocket)</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="hypt" data-env="hypt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="hypt">Hysteria2</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="tupt" data-env="tupt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="tupt">TUIC</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="sspt" data-env="sspt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="sspt">Shadowsocks-2022</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="anpt" data-env="anpt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="anpt">AnyTLS</label>
                        </div>
                        <div class="form-group toggle-group">
                            <label class="toggle-switch">
                                <input type="checkbox" id="arpt" data-env="arpt" data-value="yes">
                                <span class="slider"></span>
                            </label>
                            <label for="arpt">Any-Reality</label>
                        </div>
                    </div>
                    <div class="form-group conditional-group" id="reality-domain-group">
                        <label for="reym">Reality Domain</label>
                        <input type="text" id="reym" data-env="reym" placeholder="e.g., www.yahoo.com">
                    </div>
                     <div class="form-group conditional-group" id="cdn-hostname-group">
                        <label for="cdnym">CDN Hostname (for VMess)</label>
                        <input type="text" id="cdnym" data-env="cdnym" placeholder="Your CDN hostname">
                    </div>
                </section>

                <section class="card">
                    <h2 class="card-title">General Configuration</h2>
                    <div class="form-group">
                        <label for="uuid">UUID</label>
                        <div class="input-with-button">
                            <input type="text" id="uuid" data-env="uuid" placeholder="Leave empty to auto-generate">
                            <button type="button" id="generate-uuid">Generate</button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="name">Node Name Prefix</label>
                        <input type="text" id="name" data-env="name" placeholder="e.g., my-vps">
                    </div>
                     <div class="form-group">
                        <label for="warp">WARP Integration</label>
                        <select id="warp" data-env="warp">
                            <option value="">Disabled</option>
                            <option value="yes">Enabled (All Kernels)</option>
                            <option value="x">Enabled (Xray Only)</option>
                            <option value="s">Enabled (Sing-box Only)</option>
                        </select>
                    </div>
                </section>

                <fieldset class="card" id="argo-fieldset">
                    <h2 class="card-title">Argo Tunnel (for VMess)</h2>
                     <div class="form-group toggle-group">
                        <label class="toggle-switch">
                            <input type="checkbox" id="argo-fixed-tunnel" >
                            <span class="slider"></span>
                        </label>
                        <label for="argo-fixed-tunnel">Use Fixed Tunnel</label>
                    </div>
                    <div class="form-group conditional-group" id="argo-details-group">
                        <label for="agn">Argo Domain</label>
                        <input type="text" id="agn" data-env="agn" placeholder="your.domain.com">
                        <label for="agk">Argo Auth Token</label>
                        <input type="text" id="agk" data-env="agk" placeholder="Argo tunnel token">
                    </div>
                </fieldset>
                
                <section class="card">
                    <h2 class="card-title">IP Configuration</h2>
                    <div class="form-group">
                        <label for="ipyx">Node IP Priority</label>
                        <select id="ipyx" data-env="ipyx">
                            <option value="">Default (OS preference)</option>
                            <option value="64">IPv6 > IPv4</option>
                            <option value="46">IPv4 > IPv6</option>
                            <option value="6">IPv6 Only</option>
                            <option value="4">IPv4 Only</option>
                        </select>
                    </div>
                </section>
                 <section class="card">
                    <h2 class="card-title">Actions</h2>
                    <p>Generate a command for a specific action.</p>
                     <div class="form-group">
                        <label for="action-select">Select Action</label>
                        <select id="action-select">
                            <option value="" selected>Install / Update</option>
                            <option value="rep">Reset Protocols</option>
                            <option value="list">List Nodes</option>
                            <option value="res">Restart</option>
                            <option value="del">Uninstall</option>
                        </select>
                    </div>
                </section>
            </form>
        </main>

        <footer class="command-bar">
            <div class="command-output">
                <pre><code id="generated-command"></code></pre>
            </div>
            <button id="copy-button" aria-label="Copy command to clipboard">
                <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="M320-240q-33 0-56.5-23.5T240-320v-480q0-33 23.5-56.5T320-880h480q33 0 56.5 23.5T880-800v480q0 33-23.5 56.5T800-240H320Zm0-80h480v-480H320v480ZM160-80q-33 0-56.5-23.5T80-160v-560h80v560h560v80H160Zm160-720v480-480Z"/></svg>
                <span>Copy</span>
            </button>
        </footer>
    </div>
    <script type="module" src="index.tsx"></script>
</body>
</html>
`;

const cssContent = `
:root {
  --background-color: #f8f9fa; /* Light grey */
  --surface-color: #ffffff; /* White */
  --primary-color: #6200ee;
  --primary-variant-color: #3700b3;
  --on-background-color: #212529; /* Near black */
  --on-surface-color: #212529; /* Near black */
  --on-primary-color: #ffffff;
  --border-color: #dee2e6; /* Light grey */
  --input-background-color: #ffffff; /* White */
  --success-color: #198754; /* Green */
  --font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html, body {
  font-family: var(--font-family);
  background-color: var(--background-color);
  color: var(--on-background-color);
  line-height: 1.6;
  font-size: 16px;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem 1rem 8rem 1rem; /* Padding at bottom for command bar */
}

header {
  text-align: center;
  margin-bottom: 2rem;
}

header h1 {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--on-surface-color);
  margin-bottom: 0.5rem;
}

header p {
  font-size: 1.1rem;
  max-width: 600px;
  margin: 0 auto;
  color: #6c757d; /* Darker grey for readability */
}

.card {
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  transition: box-shadow 0.3s ease;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05); /* Add subtle shadow for depth */
}

.card:focus-within {
    box-shadow: 0 0 0 2px var(--primary-color);
}

.quick-config-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 0.75rem;
}

.quick-config-btn {
    padding: 0.75rem 1rem;
    background-color: var(--input-background-color);
    color: var(--on-background-color);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;
    text-align: center;
    font-size: 0.9rem;
}

.quick-config-btn:hover {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
    color: var(--on-primary-color);
}

.quick-config-btn:focus-visible {
    outline: none;
    box-shadow: 0 0 0 2px var(--primary-color);
}

.card-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  color: var(--on-surface-color);
}

#argo-fieldset {
  border: 1px solid var(--border-color);
}

#argo-fieldset:disabled {
    opacity: 0.5;
    pointer-events: none;
}

.form-group {
  margin-bottom: 1.25rem;
}

.form-group:last-child {
    margin-bottom: 0;
}

.form-group label {
  display: block;
  font-weight: 500;
  margin-bottom: 0.5rem;
}

input[type="text"],
select {
  width: 100%;
  padding: 0.75rem;
  background-color: var(--input-background-color);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  color: var(--on-background-color);
  font-size: 1rem;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

input[type="text"]:focus,
select:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(98, 0, 238, 0.3);
}

select {
  appearance: none;
  /* Updated SVG arrow color for light background */
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23212529' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 1em;
}

.input-with-button {
  display: flex;
  gap: 0.5rem;
}

.input-with-button input {
  flex-grow: 1;
}

.input-with-button button {
  padding: 0 1.5rem;
  background-color: var(--primary-color);
  color: var(--on-primary-color);
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.input-with-button button:hover {
  background-color: var(--primary-variant-color);
}

.protocol-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
}

.toggle-group {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    margin: 0;
}

.toggle-switch {
  position: relative;
  display: inline-block;
  width: 50px;
  height: 28px;
  flex-shrink: 0;
}

.toggle-switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ced4da; /* Light grey for off state */
  transition: .4s;
  border-radius: 28px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 20px;
  width: 20px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
  box-shadow: 0 1px 2px rgba(0,0,0,0.2); /* Add subtle shadow to handle */
}

input:checked + .slider {
  background-color: var(--primary-color);
}

input:focus-visible + .slider {
  box-shadow: 0 0 1px var(--primary-color);
}

input:checked + .slider:before {
  transform: translateX(22px);
}

.conditional-group {
    display: none;
    margin-top: 1.5rem;
}

.conditional-group.visible {
    display: block;
}

.conditional-group label {
    margin-top: 1rem;
}

.conditional-group label:first-child {
    margin-top: 0;
}


.command-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: var(--surface-color);
    border-top: 1px solid var(--border-color);
    padding: 1rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    box-shadow: 0 -2px 10px rgba(0,0,0,0.1); /* Lighter shadow */
    z-index: 100;
}

.command-output {
    flex-grow: 1;
    background-color: #e9ecef; /* Lighter background for code */
    padding: 0.75rem;
    border-radius: 8px;
    overflow-x: auto;
    max-height: 100px;
    border: 1px solid var(--border-color);
}

.command-output pre {
    white-space: pre-wrap;
    word-wrap: break-word;
}

#generated-command {
  font-family: 'Courier New', Courier, monospace;
  font-size: 0.9rem;
  color: var(--on-background-color);
}

#copy-button {
  background-color: var(--primary-color);
  color: var(--on-primary-color);
  border: none;
  border-radius: 8px;
  padding: 0.75rem 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

#copy-button:hover {
  background-color: var(--primary-variant-color);
}

#copy-button.copied {
    background-color: var(--success-color);
    color: var(--on-primary-color); /* White text on green background */
}

#copy-button svg {
  fill: currentColor;
}
`;

const tsxContent = `
/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

document.addEventListener('DOMContentLoaded', () => {
    // --- DOM Element Selectors ---
    const form = document.getElementById('config-form');
    const commandOutput = document.getElementById('generated-command');
    const copyButton = document.getElementById('copy-button');
    const generateUuidButton = document.getElementById('generate-uuid');
    const uuidInput = document.getElementById('uuid');

    // Protocol & Conditional Field Elements
    const vlptCheckbox = document.getElementById('vlpt');
    const xhptCheckbox = document.getElementById('xhpt');
    const arptCheckbox = document.getElementById('arpt');
    const vmptCheckbox = document.getElementById('vmpt');
    const hyptCheckbox = document.getElementById('hypt');
    const realityDomainGroup = document.getElementById('reality-domain-group');
    const cdnHostnameGroup = document.getElementById('cdn-hostname-group');
    
    // Argo Tunnel Elements
    const argoFieldset = document.getElementById('argo-fieldset');
    const argoFixedTunnelCheckbox = document.getElementById('argo-fixed-tunnel');
    const argoDetailsGroup = document.getElementById('argo-details-group');

    // Action Select
    const actionSelect = document.getElementById('action-select');

    // Quick Config
    const quickConfigContainer = document.querySelector('.quick-config-grid');
    const realityDomainInput = document.getElementById('reym');
    const cdnHostnameInput = document.getElementById('cdnym');
    const argoDomainInput = document.getElementById('agn');

    // --- State & Logic ---

    /**
     * Updates the visibility of conditional form fields based on protocol selections.
     */
    const updateConditionalFields = () => {
        const isRealityProtocolEnabled = vlptCheckbox.checked || xhptCheckbox.checked || arptCheckbox.checked;
        realityDomainGroup.classList.toggle('visible', isRealityProtocolEnabled);
        
        const isVmessEnabled = vmptCheckbox.checked;
        cdnHostnameGroup.classList.toggle('visible', isVmessEnabled);
        argoFieldset.disabled = !isVmessEnabled;

        const isArgoFixedTunnelEnabled = argoFixedTunnelCheckbox.checked;
        argoDetailsGroup.classList.toggle('visible', isArgoFixedTunnelEnabled && !argoFieldset.disabled);
    };

    /**
     * Generates the shell command based on the current form state.
     */
    const generateCommand = () => {
        const envVars = new Map();

        // Collect env vars from inputs, checkboxes, and selects with data-env attribute
        form.querySelectorAll('[data-env]').forEach(el => {
            const envVar = el.dataset.env;
            if (!envVar) return;

            if (el.type === 'checkbox') {
                if (el.checked) {
                    envVars.set(envVar, el.dataset.value || 'yes');
                }
            } else if (el.value) {
                envVars.set(envVar, el.value);
            }
        });
        
        // Handle Argo Tunnel specifically
        if (vmptCheckbox.checked) {
            envVars.set('argo', 'yes');
        }

        // Build the variable string part of the command
        const varString = Array.from(envVars.entries())
            .map(([key, value]) => key + '="' + value + '"')
            .join(' ');
        
        const action = actionSelect.value;
        const command = ('export ' + varString + ' && bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) ' + action).trim();

        commandOutput.textContent = command;
    };

    /**
     * Handles the copy button click event.
     */
    const handleCopy = async () => {
        if (!commandOutput.textContent) return;
        try {
            await navigator.clipboard.writeText(commandOutput.textContent);
            const originalText = copyButton.querySelector('span')?.textContent;
            copyButton.classList.add('copied');
            if (copyButton.querySelector('span')) {
               copyButton.querySelector('span').textContent = 'Copied!';
            }
            
            setTimeout(() => {
                copyButton.classList.remove('copied');
                if (copyButton.querySelector('span')) {
                    copyButton.querySelector('span').textContent = originalText || 'Copy';
                }
            }, 2000);
        } catch (err) {
            console.error('Failed to copy text: ', err);
        }
    };
    
    /**
     * Generates a v4 UUID.
     */
    const generateUuid = () => {
         // Basic UUID v4 generation for browsers that support crypto.randomUUID
        if (crypto.randomUUID) {
            return crypto.randomUUID();
        }
        // Fallback for older browsers
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    /**
     * Resets the entire form to its default state.
     */
    const resetForm = () => {
        form.reset(); 
        // Manually uncheck all protocol checkboxes as form.reset() might not work reliably for dynamically changed states
        form.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
        
        // After reset, update UI state
        updateConditionalFields();
        generateCommand();
    };

    /**
     * Applies a configuration preset to the form.
     * @param {string} preset The name of the preset to apply.
     */
    const applyPreset = (preset) => {
        resetForm(); // Start from a clean slate for all presets

        switch (preset) {
            case 'vless-reality':
                vlptCheckbox.checked = true;
                realityDomainInput.focus();
                break;

            case 'vmess-cdn':
                vmptCheckbox.checked = true;
                cdnHostnameInput.focus();
                break;
                
            case 'vmess-argo-temp':
                vmptCheckbox.checked = true;
                argoFixedTunnelCheckbox.checked = false; // Ensure it's unchecked
                cdnHostnameInput.focus();
                break;

            case 'vmess-argo-fixed':
                vmptCheckbox.checked = true;
                argoFixedTunnelCheckbox.checked = true;
                argoDomainInput.focus();
                break;

            case 'hysteria2':
                hyptCheckbox.checked = true;
                break;

            case 'reset':
                // resetForm() is already called at the start
                break;
        }
        
        // Update UI and command after applying preset
        updateConditionalFields();
        generateCommand();
    };


    // --- Event Listeners ---
    form.addEventListener('input', () => {
        updateConditionalFields();
        generateCommand();
    });

    copyButton.addEventListener('click', handleCopy);

    generateUuidButton.addEventListener('click', () => {
        uuidInput.value = generateUuid();
        // Manually trigger generation after setting value programmatically
        generateCommand();
    });

    quickConfigContainer.addEventListener('click', (e) => {
        const target = e.target;
        const button = target.closest('.quick-config-btn');
        if (button && button.dataset.preset) {
            applyPreset(button.dataset.preset);
        }
    });

    // --- Initial Setup ---
    updateConditionalFields();
    generateCommand();
});
`;

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const path = url.pathname;

    switch (path) {
      case '/':
      case '/index.html':
        return new Response(htmlContent, {
          headers: { 'Content-Type': 'text/html; charset=utf-8' },
        });

      case '/index.css':
        return new Response(cssContent, {
          headers: { 'Content-Type': 'text/css; charset=utf-8' },
        });

      case '/index.tsx':
        return new Response(tsxContent, {
          headers: { 'Content-Type': 'application/javascript; charset=utf-8' },
        });

      default:
        return new Response('Not Found', { status: 404 });
    }
  },
};
