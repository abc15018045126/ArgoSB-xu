import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';

const warpOptions = {
    '': 'Disabled',
    'yes': 'All Kernels',
    'x': 'Xray Kernel Only',
    's': 'Sing-box Kernel Only',
};

const ipyxOptions = {
    '': 'Default',
    '64': 'IPv6 Preferred',
    '46': 'IPv4 Preferred',
    '6': 'IPv6 Only',
    '4': 'IPv4 Only',
};


const App = () => {
    const [uuid, setUuid] = useState('');
    const [cdnym, setCdnym] = useState('');
    const [name, setName] = useState('');
    const [agn, setAgn] = useState('');
    const [agk, setAgk] = useState('');
    const [warp, setWarp] = useState('');
    const [ipyx, setIpyx] = useState('');

    const [generatedCommand, setGeneratedCommand] = useState('');
    const [copied, setCopied] = useState(false);

    const generateUuid = () => {
        setUuid(crypto.randomUUID());
    };

    const copyToClipboard = () => {
        navigator.clipboard.writeText(generatedCommand).then(() => {
            setCopied(true);
            setTimeout(() => setCopied(false), 2000);
        });
    };

    useEffect(() => {
        const parts = [
            'vmpt=""',
            'argo=yes'
        ];

        // Settings
        if (uuid) parts.push(`uuid='${uuid}'`);
        if (cdnym) parts.push(`cdnym='${cdnym}'`);
        if (name) parts.push(`name='${name}'`);
        if (agn) parts.push(`agn='${agn}'`);
        if (agk) parts.push(`agk='${agk}'`);
        
        // Toggles / Options
        if (warp) parts.push(`warp='${warp}'`);
        if (ipyx) parts.push(`ipyx='${ipyx}'`);
        
        const command = `export ${parts.join(' ')}; bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)`;
        setGeneratedCommand(command);
    }, [uuid, cdnym, name, agn, agk, warp, ipyx]);

    return (
        <div className="container">
            <header>
                <h1>ArgoSB VMess+Argo Configurator <span className="emoji">💣</span></h1>
                <p>Easily generate installation commands for the ArgoSB script with VMess & Argo Tunnel.</p>
            </header>

            <main>
                <fieldset>
                    <legend>Core Settings</legend>
                    <div className="form-grid">
                        <div className="form-group">
                            <label htmlFor="uuid">Custom UUID</label>
                             <div className="input-group">
                                <input type="text" id="uuid" placeholder="Auto-generated if empty" value={uuid} onChange={e => setUuid(e.target.value)} />
                                <button className="secondary" onClick={generateUuid}>Generate</button>
                            </div>
                        </div>
                        <div className="form-group">
                            <label htmlFor="name">Node Name Prefix</label>
                            <input type="text" id="name" placeholder="e.g., MyServer" value={name} onChange={e => setName(e.target.value)} />
                        </div>
                         <div className="form-group">
                            <label htmlFor="cdnym">CDN Host Domain</label>
                            <input type="text" id="cdnym" placeholder="For VMess over CDN" value={cdnym} onChange={e => setCdnym(e.target.value)} />
                        </div>
                    </div>
                </fieldset>
                
                <fieldset>
                    <legend>Network Configuration</legend>
                    <div className="form-grid">
                        <div className="form-group">
                            <label htmlFor="warp">WARP Mode</label>
                            <select id="warp" value={warp} onChange={e => setWarp(e.target.value)}>
                                {Object.entries(warpOptions).map(([key, label]) => (
                                    <option key={key} value={key}>{label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="form-group">
                            <label htmlFor="ipyx">IP Preference</label>
                            <select id="ipyx" value={ipyx} onChange={e => setIpyx(e.target.value)}>
                                {Object.entries(ipyxOptions).map(([key, label]) => (
                                    <option key={key} value={key}>{label}</option>
                                ))}
                            </select>
                        </div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>Cloudflare Argo Tunnel</legend>
                    <p className="fieldset-description">Argo Tunnel is automatically enabled for the VMess protocol.</p>
                    <div className="form-grid">
                         <div className="form-group">
                            <label htmlFor="agn">Argo Domain (Fixed Tunnel)</label>
                            <input type="text" id="agn" placeholder="Optional, for fixed domain" value={agn} onChange={e => setAgn(e.target.value)} />
                        </div>
                        <div className="form-group">
                            <label htmlFor="agk">Argo Token (Fixed Tunnel)</label>
                            <input type="text" id="agk" placeholder="Optional, for fixed token" value={agk} onChange={e => setAgk(e.target.value)} />
                        </div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>Generated Command</legend>
                    <div className="output-section">
                        <textarea readOnly value={generatedCommand}></textarea>
                        <button onClick={copyToClipboard} className={copied ? 'copied' : ''}>
                            {copied ? 'Copied!' : 'Copy'}
                        </button>
                    </div>
                </fieldset>
            </main>
        </div>
    );
};

const container = document.getElementById('root');
const root = createRoot(container!);
root.render(<App />);