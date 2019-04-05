//
//  Rates.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 03/04/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation
internal class Rates
{
    
    
    var divOrigen: String
    var divDestino: String
    
    internal init(divOrigen: String, divDestino: String) {
        self.divOrigen = divOrigen
        self.divDestino = divDestino
    }

    

    
    /*
    var aed    : Double
    var afn    : Double
    var all    : Double
    var amd    : Double
    var ang    : Double
    var aoa    : Double
    var ars    : Double
    var aud    : Double
    var awg    : Double
    var azn    : Double
    var bam    : Double
    var bbd    : Double
    var bdt    : Double
    var bgn    : Double
    var bhd    : Double
    var bif    : Double
    var bmd    : Double
    var bnd    : Double
    var bob    : Double
    var brl    : Double
    var bsd    : Double
    var btc    : Double
    var btn    : Double
    var bwp    : Double
    var byn    : Double
    var byr    : Double
    var bzd    : Double
    var cad    : Double
    var cdf    : Double
    var chf    : Double
    var clf    : Double
    var clp    : Double
    var cny    : Double
    var cop    : Double
    var crc    : Double
    var cuc    : Double
    var cup    : Double
    var cve    : Double
    var czk    : Double
    var djf    : Double
    var dkk    : Double
    var dop    : Double
    var dzd    : Double
    var egp    : Double
    var ern    : Double
    var etb    : Double
    var eur    : Double
    var fjd    : Double
    var fkp    : Double
    var gbp    : Double
    var gel    : Double
    var ggp    : Double
    var ghs    : Double
    var gip    : Double
    var gmd    : Double
    var gnf    : Double
    var gtq    : Double
    var gyd    : Double
    var hkd    : Double
    var hnl    : Double
    var hrk    : Double
    var htg    : Double
    var huf    : Double
    var idr    : Double
    var ils    : Double
    var imp    : Double
    var inr    : Double
    var iqd    : Double
    var irr    : Double
    var isk    : Double
    var jep    : Double
    var jmd    : Double
    var jod    : Double
    var jpy    : Double
    var kes    : Double
    var kgs    : Double
    var khr    : Double
    var kmf    : Double
    var kpw    : Double
    var krw    : Double
    var kwd    : Double
    var kyd    : Double
    var kzt    : Double
    var lak    : Double
    var lbp    : Double
    var lkr    : Double
    var lrd    : Double
    var lsl    : Double
    var ltl    : Double
    var lvl    : Double
    var lyd    : Double
    var mad    : Double
    var mdl    : Double
    var mga    : Double
    var mkd    : Double
    var mmk    : Double
    var mnt    : Double
    var mop    : Double
    var mro    : Double
    var mur    : Double
    var mvr    : Double
    var mwk    : Double
    var mxn    : Double
    var myr    : Double
    var mzn    : Double
    var nad    : Double
    var ngn    : Double
    var nio    : Double
    var nok    : Double
    var npr    : Double
    var nzd    : Double
    var omr    : Double
    var pab    : Double
    var pen    : Double
    var pgk    : Double
    var php    : Double
    var pkr    : Double
    var pln    : Double
    var pyg    : Double
    var qar    : Double
    var ron    : Double
    var rsd    : Double
    var rub    : Double
    var rwf    : Double
    var sar    : Double
    var sbd    : Double
    var scr    : Double
    var sdg    : Double
    var sek    : Double
    var sgd    : Double
    var shp    : Double
    var sll    : Double
    var sos    : Double
    var srd    : Double
    var std    : Double
    var svc    : Double
    var syp    : Double
    var szl    : Double
    var thb    : Double
    var tjs    : Double
    var tmt    : Double
    var tnd    : Double
    var top    : Double
    var _try    : Double
    var ttd    : Double
    var twd    : Double
    var tzs    : Double
    var uah    : Double
    var ugx    : Double
    var usd    : Double
    var uyu    : Double
    var uzs    : Double
    var vef    : Double
    var vnd    : Double
    var vuv    : Double
    var wst    : Double
    var xaf    : Double
    var xag    : Double
    var xau    : Double
    var xcd    : Double
    var xdr    : Double
    var xof    : Double
    var xpf    : Double
    var yer    : Double
    var zar    : Double
    var zmk    : Double
    var zmw    : Double
    var zwl    : Double
    
    internal init(aed: Double, afn: Double, all: Double, amd: Double, ang: Double, aoa: Double, ars: Double, aud: Double, awg: Double, azn: Double, bam: Double, bbd: Double, bdt: Double, bgn: Double, bhd: Double, bif: Double, bmd: Double, bnd: Double, bob: Double, brl: Double, bsd: Double, btc: Double, btn: Double, bwp: Double, byn: Double, byr: Double, bzd: Double, cad: Double, cdf: Double, chf: Double, clf: Double, clp: Double, cny: Double, cop: Double, crc: Double, cuc: Double, cup: Double, cve: Double, czk: Double, djf: Double, dkk: Double, dop: Double, dzd: Double, egp: Double, ern: Double, etb: Double, eur: Double, fjd: Double, fkp: Double, gbp: Double, gel: Double, ggp: Double, ghs: Double, gip: Double, gmd: Double, gnf: Double, gtq: Double, gyd: Double, hkd: Double, hnl: Double, hrk: Double, htg: Double, huf: Double, idr: Double, ils: Double, imp: Double, inr: Double, iqd: Double, irr: Double, isk: Double, jep: Double, jmd: Double, jod: Double, jpy: Double, kes: Double, kgs: Double, khr: Double, kmf: Double, kpw: Double, krw: Double, kwd: Double, kyd: Double, kzt: Double, lak: Double, lbp: Double, lkr: Double, lrd: Double, lsl: Double, ltl: Double, lvl: Double, lyd: Double, mad: Double, mdl: Double, mga: Double, mkd: Double, mmk: Double, mnt: Double, mop: Double, mro: Double, mur: Double, mvr: Double, mwk: Double, mxn: Double, myr: Double, mzn: Double, nad: Double, ngn: Double, nio: Double, nok: Double, npr: Double, nzd: Double, omr: Double, pab: Double, pen: Double, pgk: Double, php: Double, pkr: Double, pln: Double, pyg: Double, qar: Double, ron: Double, rsd: Double, rub: Double, rwf: Double, sar: Double, sbd: Double, scr: Double, sdg: Double, sek: Double, sgd: Double, shp: Double, sll: Double, sos: Double, srd: Double, std: Double, svc: Double, syp: Double, szl: Double, thb: Double, tjs: Double, tmt: Double, tnd: Double, top: Double, _try: Double, ttd: Double, twd: Double, tzs: Double, uah: Double, ugx: Double, usd: Double, uyu: Double, uzs: Double, vef: Double, vnd: Double, vuv: Double, wst: Double, xaf: Double, xag: Double, xau: Double, xcd: Double, xdr: Double, xof: Double, xpf: Double, yer: Double, zar: Double, zmk: Double, zmw: Double, zwl: Double)
    {
        self.aed = aed
        self.afn = afn
        self.all = all
        self.amd = amd
        self.ang = ang
        self.aoa = aoa
        self.ars = ars
        self.aud = aud
        self.awg = awg
        self.azn = azn
        self.bam = bam
        self.bbd = bbd
        self.bdt = bdt
        self.bgn = bgn
        self.bhd = bhd
        self.bif = bif
        self.bmd = bmd
        self.bnd = bnd
        self.bob = bob
        self.brl = brl
        self.bsd = bsd
        self.btc = btc
        self.btn = btn
        self.bwp = bwp
        self.byn = byn
        self.byr = byr
        self.bzd = bzd
        self.cad = cad
        self.cdf = cdf
        self.chf = chf
        self.clf = clf
        self.clp = clp
        self.cny = cny
        self.cop = cop
        self.crc = crc
        self.cuc = cuc
        self.cup = cup
        self.cve = cve
        self.czk = czk
        self.djf = djf
        self.dkk = dkk
        self.dop = dop
        self.dzd = dzd
        self.egp = egp
        self.ern = ern
        self.etb = etb
        self.eur = eur
        self.fjd = fjd
        self.fkp = fkp
        self.gbp = gbp
        self.gel = gel
        self.ggp = ggp
        self.ghs = ghs
        self.gip = gip
        self.gmd = gmd
        self.gnf = gnf
        self.gtq = gtq
        self.gyd = gyd
        self.hkd = hkd
        self.hnl = hnl
        self.hrk = hrk
        self.htg = htg
        self.huf = huf
        self.idr = idr
        self.ils = ils
        self.imp = imp
        self.inr = inr
        self.iqd = iqd
        self.irr = irr
        self.isk = isk
        self.jep = jep
        self.jmd = jmd
        self.jod = jod
        self.jpy = jpy
        self.kes = kes
        self.kgs = kgs
        self.khr = khr
        self.kmf = kmf
        self.kpw = kpw
        self.krw = krw
        self.kwd = kwd
        self.kyd = kyd
        self.kzt = kzt
        self.lak = lak
        self.lbp = lbp
        self.lkr = lkr
        self.lrd = lrd
        self.lsl = lsl
        self.ltl = ltl
        self.lvl = lvl
        self.lyd = lyd
        self.mad = mad
        self.mdl = mdl
        self.mga = mga
        self.mkd = mkd
        self.mmk = mmk
        self.mnt = mnt
        self.mop = mop
        self.mro = mro
        self.mur = mur
        self.mvr = mvr
        self.mwk = mwk
        self.mxn = mxn
        self.myr = myr
        self.mzn = mzn
        self.nad = nad
        self.ngn = ngn
        self.nio = nio
        self.nok = nok
        self.npr = npr
        self.nzd = nzd
        self.omr = omr
        self.pab = pab
        self.pen = pen
        self.pgk = pgk
        self.php = php
        self.pkr = pkr
        self.pln = pln
        self.pyg = pyg
        self.qar = qar
        self.ron = ron
        self.rsd = rsd
        self.rub = rub
        self.rwf = rwf
        self.sar = sar
        self.sbd = sbd
        self.scr = scr
        self.sdg = sdg
        self.sek = sek
        self.sgd = sgd
        self.shp = shp
        self.sll = sll
        self.sos = sos
        self.srd = srd
        self.std = std
        self.svc = svc
        self.syp = syp
        self.szl = szl
        self.thb = thb
        self.tjs = tjs
        self.tmt = tmt
        self.tnd = tnd
        self.top = top
        self._try = _try
        self.ttd = ttd
        self.twd = twd
        self.tzs = tzs
        self.uah = uah
        self.ugx = ugx
        self.usd = usd
        self.uyu = uyu
        self.uzs = uzs
        self.vef = vef
        self.vnd = vnd
        self.vuv = vuv
        self.wst = wst
        self.xaf = xaf
        self.xag = xag
        self.xau = xau
        self.xcd = xcd
        self.xdr = xdr
        self.xof = xof
        self.xpf = xpf
        self.yer = yer
        self.zar = zar
        self.zmk = zmk
        self.zmw = zmw
        self.zwl = zwl
    }
    */
    
    

}
